using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using PPDG3P.Api.Models;
using PPDG3P.Api.Services;

namespace PPDG3P.Api.Controllers;

/// <summary>
/// Controller for handling KDT (table-per-subtype / specialization) operations.
/// Manages parent-child table relationships where one entity is split across multiple tables.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class KdtController : ControllerBase
{
    private readonly IMetadataService _metadataService;
    private readonly IConfiguration _configuration;
    private readonly string _connectionString;

    // Pre-defined KDT hierarchies in the database
    private static readonly List<KdtHierarchy> _hierarchies = new()
    {
        new KdtHierarchy
        {
            Name = "Lice",
            ParentTable = "Lice",
            ParentKeyColumn = "JMBG/ESB/PIB",
            ChildTables = new List<KdtChildTable>
            {
                new() { TableName = "Fizicko", ForeignKeyColumn = "JMGB/ESB/PIB_lice", TypeDiscriminator = "FIZICKO" },
                new() { TableName = "Pravno", ForeignKeyColumn = "JMGB/ESB/PIB_lice", TypeDiscriminator = "PRAVNO" },
                new() { TableName = "Broker", ForeignKeyColumn = "JMGB/ESB/PIB_lice", TypeDiscriminator = "BROKER" }
            }
        },
        new KdtHierarchy
        {
            Name = "StavkaUmanjenja",
            ParentTable = "StavkaUmanjenja",
            ParentKeyColumn = "ID",
            ChildTables = new List<KdtChildTable>
            {
                new() { TableName = "KapitalniGubitak", ForeignKeyColumn = "IDStavkeUmanjenja", TypeDiscriminator = "KAP_GUB" },
                new() { TableName = "UlaganjeUOsnKap", ForeignKeyColumn = "IDStavkeUmanjenja", TypeDiscriminator = "OSN_KAP" },
                new() { TableName = "UlaganjneUResavanjeSP", ForeignKeyColumn = "IDStavkeUmanjenja", TypeDiscriminator = "RES_SP" }
            }
        },
        new KdtHierarchy
        {
            Name = "StavkaPrenosa",
            ParentTable = "StavkaPrenosa",
            ParentKeyColumn = "ID",
            ChildTables = new List<KdtChildTable>
            {
                new() { TableName = "PrenosHartijaOdVrednosti", ForeignKeyColumn = "IDStavkePrenosa", TypeDiscriminator = "HARTIJE" }
            }
        },
        new KdtHierarchy
        {
            Name = "PoreskiObveznik",
            ParentTable = "PoreskiObveznik",
            ParentKeyColumn = "JMBG/ESB/PIB_lice",
            ChildTables = new List<KdtChildTable>
            {
                new() { TableName = "PoreskiObveznik_Details", ForeignKeyColumn = "JMBG/ESB/PIB", TypeDiscriminator = "DETAILS" }
            }
        }
    };

    public KdtController(IMetadataService metadataService, IConfiguration configuration)
    {
        _metadataService = metadataService;
        _configuration = configuration;
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Connection string not found.");
    }

    private string Schema => _configuration["DatabaseSchema"] ?? "ppdg3p";

    /// <summary>
    /// Get all defined KDT hierarchies
    /// </summary>
    [HttpGet("hierarchies")]
    public IActionResult GetHierarchies()
    {
        return Ok(_hierarchies);
    }

    /// <summary>
    /// Get a specific KDT hierarchy by name
    /// </summary>
    [HttpGet("hierarchies/{name}")]
    public IActionResult GetHierarchy(string name)
    {
        var hierarchy = _hierarchies.FirstOrDefault(h =>
            h.Name.Equals(name, StringComparison.OrdinalIgnoreCase));

        if (hierarchy == null)
            return NotFound(new { Message = $"KDT hierarchy '{name}' not found." });

        return Ok(hierarchy);
    }

    /// <summary>
    /// Get joined data from parent and all matching child tables
    /// </summary>
    [HttpGet("{hierarchyName}")]
    public async Task<IActionResult> GetAll(string hierarchyName)
    {
        var hierarchy = _hierarchies.FirstOrDefault(h =>
            h.Name.Equals(hierarchyName, StringComparison.OrdinalIgnoreCase));

        if (hierarchy == null)
            return NotFound(new { Message = $"KDT hierarchy '{hierarchyName}' not found." });

        // Build a query that joins parent with all child tables
        var sql = $@"
            SELECT
                p.*,
                {string.Join(",\n", hierarchy.ChildTables.Select(c =>
                    $"CASE WHEN c_{c.TableName}.[{c.ForeignKeyColumn}] IS NOT NULL THEN '{c.TypeDiscriminator}' ELSE NULL END AS [_Type_{c.TableName}]"))}
            FROM [{Schema}].[{hierarchy.ParentTable}] p
            {string.Join("\n", hierarchy.ChildTables.Select(c =>
                $"LEFT JOIN [{Schema}].[{c.TableName}] c_{c.TableName} ON p.[{hierarchy.ParentKeyColumn}] = c_{c.TableName}.[{c.ForeignKeyColumn}]"))}";

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand(sql, connection);
        using var reader = await command.ExecuteReaderAsync();

        var rows = new List<Dictionary<string, object?>>();

        while (await reader.ReadAsync())
        {
            var row = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                var value = reader.GetValue(i);
                row[reader.GetName(i)] = value == DBNull.Value ? null : value;
            }
            rows.Add(row);
        }

        return Ok(new { Rows = rows, TotalCount = rows.Count });
    }

    /// <summary>
    /// Get a specific record with its child data
    /// </summary>
    [HttpGet("{hierarchyName}/{keyValue}")]
    public async Task<IActionResult> GetByKey(string hierarchyName, string keyValue)
    {
        var hierarchy = _hierarchies.FirstOrDefault(h =>
            h.Name.Equals(hierarchyName, StringComparison.OrdinalIgnoreCase));

        if (hierarchy == null)
            return NotFound(new { Message = $"KDT hierarchy '{hierarchyName}' not found." });

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var result = new Dictionary<string, object?>();

        // Get parent data
        var parentSql = $"SELECT * FROM [{Schema}].[{hierarchy.ParentTable}] WHERE [{hierarchy.ParentKeyColumn}] = @Key";
        using (var cmd = new SqlCommand(parentSql, connection))
        {
            cmd.Parameters.AddWithValue("@Key", keyValue);
            using var reader = await cmd.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                result["Parent"] = ReadRow(reader);
            }
            else
            {
                return NotFound(new { Message = $"Record with key '{keyValue}' not found." });
            }
        }

        // Get child data for each child table
        var children = new Dictionary<string, object?>();
        foreach (var child in hierarchy.ChildTables)
        {
            var childSql = $"SELECT * FROM [{Schema}].[{child.TableName}] WHERE [{child.ForeignKeyColumn}] = @Key";
            using var cmd = new SqlCommand(childSql, connection);
            cmd.Parameters.AddWithValue("@Key", keyValue);
            using var reader = await cmd.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                children[child.TableName] = ReadRow(reader);
                result["Type"] = child.TypeDiscriminator;
            }
        }

        result["Children"] = children;
        return Ok(result);
    }

    /// <summary>
    /// Insert into parent and child tables in a single transaction
    /// </summary>
    [HttpPost("{hierarchyName}/{childType}")]
    public async Task<IActionResult> Insert(string hierarchyName, string childType, [FromBody] KdtInsertRequest request)
    {
        var hierarchy = _hierarchies.FirstOrDefault(h =>
            h.Name.Equals(hierarchyName, StringComparison.OrdinalIgnoreCase));

        if (hierarchy == null)
            return NotFound(new { Message = $"KDT hierarchy '{hierarchyName}' not found." });

        var childTable = hierarchy.ChildTables.FirstOrDefault(c =>
            c.TypeDiscriminator.Equals(childType, StringComparison.OrdinalIgnoreCase) ||
            c.TableName.Equals(childType, StringComparison.OrdinalIgnoreCase));

        if (childTable == null)
            return NotFound(new { Message = $"Child type '{childType}' not found in hierarchy '{hierarchyName}'." });

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var transaction = connection.BeginTransaction();

        try
        {
            object? insertedKey = null;

            // Insert into parent table
            if (request.ParentValues.Count > 0)
            {
                var parentColumns = string.Join(", ", request.ParentValues.Keys.Select(k => $"[{k}]"));
                var parentParams = string.Join(", ", request.ParentValues.Keys.Select((k, i) => $"@p{i}"));

                var parentSql = $@"
                    INSERT INTO [{Schema}].[{hierarchy.ParentTable}] ({parentColumns})
                    OUTPUT INSERTED.[{hierarchy.ParentKeyColumn}]
                    VALUES ({parentParams})";

                using var cmd = new SqlCommand(parentSql, connection, transaction);

                int i = 0;
                foreach (var kvp in request.ParentValues)
                {
                    cmd.Parameters.AddWithValue($"@p{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
                    i++;
                }

                insertedKey = await cmd.ExecuteScalarAsync();
            }

            // Insert into child table
            if (request.ChildValues.Count > 0)
            {
                // Add the foreign key to child values if we have an inserted key
                var childValues = new Dictionary<string, object?>(
                    request.ChildValues.Select(kvp => new KeyValuePair<string, object?>(kvp.Key, ConvertJsonElement(kvp.Value))));

                if (insertedKey != null)
                {
                    childValues[childTable.ForeignKeyColumn] = insertedKey;
                }

                var childColumns = string.Join(", ", childValues.Keys.Select(k => $"[{k}]"));
                var childParams = string.Join(", ", childValues.Keys.Select((k, i) => $"@c{i}"));

                var childSql = $@"
                    INSERT INTO [{Schema}].[{childTable.TableName}] ({childColumns})
                    VALUES ({childParams})";

                using var cmd = new SqlCommand(childSql, connection, transaction);

                int i = 0;
                foreach (var kvp in childValues)
                {
                    cmd.Parameters.AddWithValue($"@c{i}", kvp.Value ?? DBNull.Value);
                    i++;
                }

                await cmd.ExecuteNonQueryAsync();
            }

            await transaction.CommitAsync();

            return Ok(new
            {
                Message = "Insert successful",
                InsertedKey = insertedKey
            });
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    /// <summary>
    /// Update parent and/or child tables in a single transaction
    /// </summary>
    [HttpPut("{hierarchyName}/{childType}")]
    public async Task<IActionResult> Update(string hierarchyName, string childType, [FromBody] KdtUpdateRequest request)
    {
        var hierarchy = _hierarchies.FirstOrDefault(h =>
            h.Name.Equals(hierarchyName, StringComparison.OrdinalIgnoreCase));

        if (hierarchy == null)
            return NotFound(new { Message = $"KDT hierarchy '{hierarchyName}' not found." });

        var childTable = hierarchy.ChildTables.FirstOrDefault(c =>
            c.TypeDiscriminator.Equals(childType, StringComparison.OrdinalIgnoreCase) ||
            c.TableName.Equals(childType, StringComparison.OrdinalIgnoreCase));

        if (childTable == null)
            return NotFound(new { Message = $"Child type '{childType}' not found in hierarchy '{hierarchyName}'." });

        if (request.Keys.Count == 0)
            return BadRequest(new { Message = "No key columns provided." });

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var transaction = connection.BeginTransaction();

        try
        {
            int totalAffected = 0;

            // Update parent table
            if (request.ParentValues.Count > 0)
            {
                var setClauses = request.ParentValues.Keys.Select((k, i) => $"[{k}] = @v{i}");
                var whereClauses = request.Keys.Keys.Select((k, i) => $"[{k}] = @k{i}");

                var parentSql = $@"
                    UPDATE [{Schema}].[{hierarchy.ParentTable}]
                    SET {string.Join(", ", setClauses)}
                    WHERE {string.Join(" AND ", whereClauses)}";

                using var cmd = new SqlCommand(parentSql, connection, transaction);

                int i = 0;
                foreach (var kvp in request.ParentValues)
                {
                    cmd.Parameters.AddWithValue($"@v{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
                    i++;
                }

                i = 0;
                foreach (var kvp in request.Keys)
                {
                    cmd.Parameters.AddWithValue($"@k{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
                    i++;
                }

                totalAffected += await cmd.ExecuteNonQueryAsync();
            }

            // Update child table
            if (request.ChildValues.Count > 0)
            {
                var setClauses = request.ChildValues.Keys.Select((k, i) => $"[{k}] = @cv{i}");

                // Use the first key value for the child FK
                var keyValue = ConvertJsonElement(request.Keys.Values.First());

                var childSql = $@"
                    UPDATE [{Schema}].[{childTable.TableName}]
                    SET {string.Join(", ", setClauses)}
                    WHERE [{childTable.ForeignKeyColumn}] = @ck";

                using var cmd = new SqlCommand(childSql, connection, transaction);

                int i = 0;
                foreach (var kvp in request.ChildValues)
                {
                    cmd.Parameters.AddWithValue($"@cv{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
                    i++;
                }

                cmd.Parameters.AddWithValue("@ck", keyValue ?? DBNull.Value);

                totalAffected += await cmd.ExecuteNonQueryAsync();
            }

            await transaction.CommitAsync();

            return Ok(new { AffectedRows = totalAffected });
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    /// <summary>
    /// Delete from child and parent tables (child first due to FK)
    /// </summary>
    [HttpDelete("{hierarchyName}")]
    public async Task<IActionResult> Delete(string hierarchyName, [FromBody] DeleteRequest request)
    {
        var hierarchy = _hierarchies.FirstOrDefault(h =>
            h.Name.Equals(hierarchyName, StringComparison.OrdinalIgnoreCase));

        if (hierarchy == null)
            return NotFound(new { Message = $"KDT hierarchy '{hierarchyName}' not found." });

        if (request.Keys.Count == 0)
            return BadRequest(new { Message = "No key columns provided." });

        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var transaction = connection.BeginTransaction();

        try
        {
            var keyValue = ConvertJsonElement(request.Keys.Values.First());
            int totalAffected = 0;

            // Delete from all child tables first (cascade may handle this, but be explicit)
            foreach (var child in hierarchy.ChildTables)
            {
                var childSql = $"DELETE FROM [{Schema}].[{child.TableName}] WHERE [{child.ForeignKeyColumn}] = @k";
                using var cmd = new SqlCommand(childSql, connection, transaction);
                cmd.Parameters.AddWithValue("@k", keyValue ?? DBNull.Value);
                totalAffected += await cmd.ExecuteNonQueryAsync();
            }

            // Delete from parent table
            var whereClauses = request.Keys.Keys.Select((k, i) => $"[{k}] = @pk{i}");
            var parentSql = $"DELETE FROM [{Schema}].[{hierarchy.ParentTable}] WHERE {string.Join(" AND ", whereClauses)}";

            using (var cmd = new SqlCommand(parentSql, connection, transaction))
            {
                int i = 0;
                foreach (var kvp in request.Keys)
                {
                    cmd.Parameters.AddWithValue($"@pk{i}", ConvertJsonElement(kvp.Value) ?? DBNull.Value);
                    i++;
                }

                totalAffected += await cmd.ExecuteNonQueryAsync();
            }

            await transaction.CommitAsync();

            return Ok(new { AffectedRows = totalAffected });
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    private static Dictionary<string, object?> ReadRow(SqlDataReader reader)
    {
        var row = new Dictionary<string, object?>();
        for (int i = 0; i < reader.FieldCount; i++)
        {
            var value = reader.GetValue(i);
            row[reader.GetName(i)] = value == DBNull.Value ? null : value;
        }
        return row;
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
