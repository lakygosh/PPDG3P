using Microsoft.Data.SqlClient;
using PPDG3P.Api.Models;

namespace PPDG3P.Api.Services;

public class MetadataService : IMetadataService
{
    private readonly string _connectionString;
    private readonly string _schema;

    public MetadataService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
        _schema = configuration["DatabaseSchema"] ?? "ppdg3p";
    }

    public async Task<List<TableMetadata>> GetAllTablesAsync()
    {
        return await GetTablesOrViewsAsync("BASE TABLE");
    }

    public async Task<List<TableMetadata>> GetAllViewsAsync()
    {
        return await GetTablesOrViewsAsync("VIEW");
    }

    private async Task<List<TableMetadata>> GetTablesOrViewsAsync(string tableType)
    {
        var tables = new List<TableMetadata>();

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        // Get all tables/views
        var sql = @"
            SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = @Schema AND TABLE_TYPE = @TableType
            ORDER BY TABLE_NAME";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Schema", _schema);
        command.Parameters.AddWithValue("@TableType", tableType);

        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            tables.Add(new TableMetadata
            {
                SchemaName = reader.GetString(0),
                TableName = reader.GetString(1),
                TableType = reader.GetString(2)
            });
        }

        // For each table, get metadata
        foreach (var table in tables)
        {
            var metadata = await GetTableMetadataInternalAsync(connection, table.TableName, table.TableType);
            if (metadata != null)
            {
                table.Columns = metadata.Columns;
                table.ForeignKeys = metadata.ForeignKeys;
                table.PrimaryKeyColumns = metadata.PrimaryKeyColumns;
            }
        }

        return tables;
    }

    public async Task<TableMetadata?> GetTableMetadataAsync(string tableName)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        // First check if table exists and get its type
        var sql = @"
            SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableName";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Schema", _schema);
        command.Parameters.AddWithValue("@TableName", tableName);

        using var reader = await command.ExecuteReaderAsync();

        if (!await reader.ReadAsync())
            return null;

        var tableType = reader.GetString(2);
        await reader.CloseAsync();

        return await GetTableMetadataInternalAsync(connection, tableName, tableType);
    }

    private async Task<TableMetadata?> GetTableMetadataInternalAsync(SqlConnection connection, string tableName, string tableType)
    {
        var metadata = new TableMetadata
        {
            SchemaName = _schema,
            TableName = tableName,
            TableType = tableType
        };

        // Get columns
        var columnsSql = @"
            SELECT
                c.COLUMN_NAME,
                c.DATA_TYPE,
                c.CHARACTER_MAXIMUM_LENGTH,
                c.NUMERIC_PRECISION,
                c.NUMERIC_SCALE,
                CASE WHEN c.IS_NULLABLE = 'YES' THEN 1 ELSE 0 END AS IsNullable,
                CASE WHEN ic.object_id IS NOT NULL THEN 1 ELSE 0 END AS IsIdentity,
                c.COLUMN_DEFAULT,
                c.ORDINAL_POSITION
            FROM INFORMATION_SCHEMA.COLUMNS c
            LEFT JOIN sys.identity_columns ic
                ON ic.object_id = OBJECT_ID(@FullTableName)
                AND ic.name = c.COLUMN_NAME
            WHERE c.TABLE_SCHEMA = @Schema AND c.TABLE_NAME = @TableName
            ORDER BY c.ORDINAL_POSITION";

        using (var colCommand = new SqlCommand(columnsSql, connection))
        {
            colCommand.Parameters.AddWithValue("@Schema", _schema);
            colCommand.Parameters.AddWithValue("@TableName", tableName);
            colCommand.Parameters.AddWithValue("@FullTableName", $"{_schema}.{tableName}");

            using var colReader = await colCommand.ExecuteReaderAsync();

            while (await colReader.ReadAsync())
            {
                metadata.Columns.Add(new ColumnMetadata
                {
                    ColumnName = colReader.GetString(0),
                    DataType = colReader.GetString(1),
                    MaxLength = colReader.IsDBNull(2) ? null : colReader.GetInt32(2),
                    NumericPrecision = colReader.IsDBNull(3) ? null : Convert.ToInt32(colReader.GetByte(3)),
                    NumericScale = colReader.IsDBNull(4) ? null : colReader.GetInt32(4),
                    IsNullable = colReader.GetInt32(5) == 1,
                    IsIdentity = colReader.GetInt32(6) == 1,
                    DefaultValue = colReader.IsDBNull(7) ? null : colReader.GetString(7),
                    OrdinalPosition = colReader.GetInt32(8)
                });
            }
        }

        // Get primary key columns (only for tables, not views)
        if (tableType == "BASE TABLE")
        {
            var pkSql = @"
                SELECT COLUMN_NAME
                FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                WHERE OBJECTPROPERTY(OBJECT_ID(CONSTRAINT_SCHEMA + '.' + QUOTENAME(CONSTRAINT_NAME)), 'IsPrimaryKey') = 1
                    AND TABLE_SCHEMA = @Schema
                    AND TABLE_NAME = @TableName
                ORDER BY ORDINAL_POSITION";

            using (var pkCommand = new SqlCommand(pkSql, connection))
            {
                pkCommand.Parameters.AddWithValue("@Schema", _schema);
                pkCommand.Parameters.AddWithValue("@TableName", tableName);

                using var pkReader = await pkCommand.ExecuteReaderAsync();

                while (await pkReader.ReadAsync())
                {
                    var pkColumn = pkReader.GetString(0);
                    metadata.PrimaryKeyColumns.Add(pkColumn);

                    // Mark column as primary key
                    var col = metadata.Columns.FirstOrDefault(c => c.ColumnName == pkColumn);
                    if (col != null)
                        col.IsPrimaryKey = true;
                }
            }

            // Get foreign keys
            var fkSql = @"
                SELECT
                    fk.name AS ConstraintName,
                    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
                    SCHEMA_NAME(ref_t.schema_id) AS ReferencedSchema,
                    ref_t.name AS ReferencedTable,
                    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn,
                    fk.delete_referential_action_desc AS DeleteRule,
                    fk.update_referential_action_desc AS UpdateRule
                FROM sys.foreign_keys fk
                INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
                INNER JOIN sys.tables ref_t ON fkc.referenced_object_id = ref_t.object_id
                WHERE fk.parent_object_id = OBJECT_ID(@FullTableName)
                ORDER BY fk.name, fkc.constraint_column_id";

            using (var fkCommand = new SqlCommand(fkSql, connection))
            {
                fkCommand.Parameters.AddWithValue("@FullTableName", $"{_schema}.{tableName}");

                using var fkReader = await fkCommand.ExecuteReaderAsync();

                while (await fkReader.ReadAsync())
                {
                    metadata.ForeignKeys.Add(new ForeignKeyMetadata
                    {
                        ConstraintName = fkReader.GetString(0),
                        ColumnName = fkReader.GetString(1),
                        ReferencedSchema = fkReader.GetString(2),
                        ReferencedTable = fkReader.GetString(3),
                        ReferencedColumn = fkReader.GetString(4),
                        DeleteRule = fkReader.GetString(5),
                        UpdateRule = fkReader.GetString(6)
                    });
                }
            }
        }

        return metadata;
    }

    public async Task<bool> IsValidTableOrViewAsync(string name)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = @"
            SELECT COUNT(1)
            FROM INFORMATION_SCHEMA.TABLES
            WHERE TABLE_SCHEMA = @Schema AND TABLE_NAME = @TableName";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Schema", _schema);
        command.Parameters.AddWithValue("@TableName", name);

        var result = await command.ExecuteScalarAsync();
        return Convert.ToInt32(result) > 0;
    }

    public async Task<bool> IsValidColumnAsync(string tableName, string columnName)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = @"
            SELECT COUNT(1)
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = @Schema
                AND TABLE_NAME = @TableName
                AND COLUMN_NAME = @ColumnName";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Schema", _schema);
        command.Parameters.AddWithValue("@TableName", tableName);
        command.Parameters.AddWithValue("@ColumnName", columnName);

        var result = await command.ExecuteScalarAsync();
        return Convert.ToInt32(result) > 0;
    }

    public async Task<List<string>> GetStoredProceduresAsync()
    {
        var procedures = new List<string>();

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = @"
            SELECT ROUTINE_NAME
            FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_SCHEMA = @Schema AND ROUTINE_TYPE = 'PROCEDURE'
            ORDER BY ROUTINE_NAME";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Schema", _schema);

        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            procedures.Add(reader.GetString(0));
        }

        return procedures;
    }
}
