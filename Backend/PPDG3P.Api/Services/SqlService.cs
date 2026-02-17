using System.Data;
using System.Text.Json;
using Microsoft.Data.SqlClient;
using PPDG3P.Api.Models;

namespace PPDG3P.Api.Services;

public class SqlService : ISqlService
{
    private readonly string _connectionString;
    private readonly string _schema;

    public SqlService(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
        _schema = configuration["DatabaseSchema"] ?? "ppdg3p";
    }

    public async Task<QueryResult> ExecuteQueryAsync(string sql, Dictionary<string, object?>? parameters = null)
    {
        var result = new QueryResult { Rows = new List<Dictionary<string, object?>>() };

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand(sql, connection);
        AddParameters(command, parameters);

        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            var row = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                var value = reader.GetValue(i);
                row[reader.GetName(i)] = value == DBNull.Value ? null : value;
            }
            result.Rows.Add(row);
        }

        result.TotalCount = result.Rows.Count;
        return result;
    }

    public async Task<InsertResult> ExecuteInsertAsync(string tableName, Dictionary<string, JsonElement> values)
    {
        if (values.Count == 0)
            throw new ArgumentException("No values provided for insert.");

        var columns = string.Join(", ", values.Keys.Select(k => $"[{k}]"));
        var paramNames = string.Join(", ", values.Keys.Select((k, i) => $"@p{i}"));

        // Use OUTPUT INTO to avoid trigger conflicts
        var sql = $@"
            INSERT INTO [{_schema}].[{tableName}] ({columns})
            VALUES ({paramNames});

            SELECT * FROM [{_schema}].[{tableName}]
            WHERE ID = SCOPE_IDENTITY();";

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand(sql, connection);

        int i = 0;
        foreach (var kvp in values)
        {
            command.Parameters.AddWithValue($"@p{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
            i++;
        }

        var result = new InsertResult();

        using var reader = await command.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            result.AffectedRows = 1;
            result.InsertedRow = new Dictionary<string, object?>();
            for (int j = 0; j < reader.FieldCount; j++)
            {
                var value = reader.GetValue(j);
                result.InsertedRow[reader.GetName(j)] = value == DBNull.Value ? null : value;
            }
        }

        return result;
    }

    public async Task<int> ExecuteUpdateAsync(string tableName, Dictionary<string, JsonElement> keys, Dictionary<string, JsonElement> values)
    {
        if (keys.Count == 0)
            throw new ArgumentException("No key columns provided for update.");
        if (values.Count == 0)
            throw new ArgumentException("No values provided for update.");

        var setClauses = values.Keys.Select((k, i) => $"[{k}] = @v{i}");
        var whereClauses = keys.Keys.Select((k, i) => $"[{k}] = @k{i}");

        var sql = $@"
            UPDATE [{_schema}].[{tableName}]
            SET {string.Join(", ", setClauses)}
            WHERE {string.Join(" AND ", whereClauses)}";

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand(sql, connection);

        int i = 0;
        foreach (var kvp in values)
        {
            command.Parameters.AddWithValue($"@v{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
            i++;
        }

        i = 0;
        foreach (var kvp in keys)
        {
            command.Parameters.AddWithValue($"@k{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
            i++;
        }

        return await command.ExecuteNonQueryAsync();
    }

    public async Task<int> ExecuteDeleteAsync(string tableName, Dictionary<string, JsonElement> keys)
    {
        if (keys.Count == 0)
            throw new ArgumentException("No key columns provided for delete.");

        var whereClauses = keys.Keys.Select((k, i) => $"[{k}] = @k{i}");

        var sql = $@"
            DELETE FROM [{_schema}].[{tableName}]
            WHERE {string.Join(" AND ", whereClauses)}";

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand(sql, connection);

        int i = 0;
        foreach (var kvp in keys)
        {
            command.Parameters.AddWithValue($"@k{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
            i++;
        }

        return await command.ExecuteNonQueryAsync();
    }

    public async Task<int> ExecuteNonQueryAsync(string sql, Dictionary<string, object?>? parameters = null)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand(sql, connection);
        AddParameters(command, parameters);

        return await command.ExecuteNonQueryAsync();
    }

    public async Task<QueryResult> ExecuteStoredProcedureAsync(string procedureName, Dictionary<string, JsonElement>? parameters = null)
    {
        var result = new QueryResult { Rows = new List<Dictionary<string, object?>>() };

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand($"[{_schema}].[{procedureName}]", connection)
        {
            CommandType = CommandType.StoredProcedure
        };

        if (parameters != null)
        {
            foreach (var kvp in parameters)
            {
                command.Parameters.AddWithValue($"@{kvp.Key}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
            }
        }

        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            var row = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                var value = reader.GetValue(i);
                row[reader.GetName(i)] = value == DBNull.Value ? null : value;
            }
            result.Rows.Add(row);
        }

        result.TotalCount = result.Rows.Count;
        return result;
    }

    private static void AddParameters(SqlCommand command, Dictionary<string, object?>? parameters)
    {
        if (parameters == null) return;

        foreach (var kvp in parameters)
        {
            command.Parameters.AddWithValue($"@{kvp.Key}", kvp.Value ?? DBNull.Value);
        }
    }

    private static object? ConvertJsonElement(JsonElement element)
    {
        return element.ValueKind switch
        {
            JsonValueKind.Null => null,
            JsonValueKind.String => element.GetString(),
            JsonValueKind.Number when element.TryGetInt32(out int intVal) => intVal,
            JsonValueKind.Number when element.TryGetInt64(out long longVal) => longVal,
            JsonValueKind.Number => element.GetDecimal(),
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            _ => element.ToString()
        };
    }
}
