using System.Text.Json;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
namespace PPDG3P.Api.Controllers;

/// <summary>
/// Controller for working with PPDG3P documents (the main form entity).
/// Uses the view and stored procedure defined in the database.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class DocumentController : ControllerBase
{
    private readonly IConfiguration _configuration;
    private readonly string _connectionString;

    public DocumentController(IConfiguration configuration)
    {
        _configuration = configuration;
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Connection string not found.");
    }

    private string Schema => _configuration["DatabaseSchema"] ?? "ppdg3p";

    /// <summary>
    /// Get all PPDG3P documents as JSON (using the view)
    /// </summary>
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = $"SELECT IDPrijave, JsonDoc FROM [{Schema}].[vw_PPDG3P_Document]";

        using var command = new SqlCommand(sql, connection);
        using var reader = await command.ExecuteReaderAsync();

        var documents = new List<object>();

        while (await reader.ReadAsync())
        {
            var id = reader.GetInt32(0);
            var jsonDoc = reader.IsDBNull(1) ? null : reader.GetString(1);

            if (!string.IsNullOrEmpty(jsonDoc))
            {
                try
                {
                    var doc = JsonSerializer.Deserialize<JsonElement>(jsonDoc);
                    documents.Add(new { Id = id, Document = doc });
                }
                catch
                {
                    documents.Add(new { Id = id, Document = (object?)null, RawJson = jsonDoc });
                }
            }
            else
            {
                documents.Add(new { Id = id, Document = (object?)null });
            }
        }

        return Ok(documents);
    }

    /// <summary>
    /// Get a specific PPDG3P document by ID
    /// </summary>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = $"SELECT IDPrijave, JsonDoc FROM [{Schema}].[vw_PPDG3P_Document] WHERE IDPrijave = @Id";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Id", id);

        using var reader = await command.ExecuteReaderAsync();

        if (!await reader.ReadAsync())
            return NotFound(new { Message = $"Document with ID {id} not found." });

        var idPrijave = reader.GetInt32(0);
        var jsonDoc = reader.IsDBNull(1) ? null : reader.GetString(1);

        if (string.IsNullOrEmpty(jsonDoc))
            return Ok(new { Id = idPrijave, Document = (object?)null });

        try
        {
            var doc = JsonSerializer.Deserialize<JsonElement>(jsonDoc);
            return Ok(new { Id = idPrijave, Document = doc });
        }
        catch
        {
            return Ok(new { Id = idPrijave, Document = (object?)null, RawJson = jsonDoc });
        }
    }

    /// <summary>
    /// Update a PPDG3P document using the stored procedure
    /// </summary>
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, [FromBody] JsonElement jsonDoc)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var jsonString = jsonDoc.GetRawText();

        using var command = new SqlCommand($"[{Schema}].[UpsertPPDG3PDocumentFromJson]", connection);
        command.CommandType = System.Data.CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@IDPrijave", id);
        command.Parameters.AddWithValue("@JsonDoc", jsonString);
        command.Parameters.AddWithValue("@Sync", true);

        await command.ExecuteNonQueryAsync();

        return Ok(new { Message = "Document updated successfully." });
    }

    /// <summary>
    /// Partial update (PATCH) - only updates provided fields
    /// </summary>
    [HttpPatch("{id}")]
    public async Task<IActionResult> PartialUpdate(int id, [FromBody] JsonElement jsonDoc)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var jsonString = jsonDoc.GetRawText();

        using var command = new SqlCommand($"[{Schema}].[UpsertPPDG3PDocumentFromJson]", connection);
        command.CommandType = System.Data.CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@IDPrijave", id);
        command.Parameters.AddWithValue("@JsonDoc", jsonString);
        command.Parameters.AddWithValue("@Sync", false); // Partial update mode

        await command.ExecuteNonQueryAsync();

        return Ok(new { Message = "Document partially updated successfully." });
    }

    /// <summary>
    /// Recalculate totals for a PPDG3P document
    /// </summary>
    [HttpPost("{id}/recalculate")]
    public async Task<IActionResult> Recalculate(int id)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand($"[{Schema}].[PPDG3P_OsnovicaCalc]", connection);
        command.CommandType = System.Data.CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@IDPrijave", id);

        await command.ExecuteNonQueryAsync();

        return Ok(new { Message = "Totals recalculated successfully." });
    }

    /// <summary>
    /// Create a new PPDG3P document using the stored procedure.
    /// Passing NULL for @IDPrijave triggers CREATE mode (auto-creates Lice/PoreskiObveznik if missing).
    /// </summary>
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] JsonElement jsonDoc)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        using var command = new SqlCommand($"[{Schema}].[UpsertPPDG3PDocumentFromJson]", connection);
        command.CommandType = System.Data.CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@IDPrijave", DBNull.Value);
        command.Parameters.AddWithValue("@JsonDoc", jsonDoc.GetRawText());
        command.Parameters.AddWithValue("@Sync", true);

        var newId = Convert.ToInt32(await command.ExecuteScalarAsync());

        return CreatedAtAction(nameof(GetById), new { id = newId }, new { Id = newId });
    }

    /// <summary>
    /// Delete a PPDG3P document (cascades to related tables)
    /// </summary>
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        using var connection = new SqlConnection(_connectionString);
        await connection.OpenAsync();

        var sql = $"DELETE FROM [{Schema}].[PPDG3P] WHERE ID = @Id";

        using var command = new SqlCommand(sql, connection);
        command.Parameters.AddWithValue("@Id", id);

        var affected = await command.ExecuteNonQueryAsync();

        if (affected == 0)
            return NotFound(new { Message = $"Document with ID {id} not found." });

        return Ok(new { AffectedRows = affected });
    }
}


