using Microsoft.AspNetCore.Mvc;
using PPDG3P.Api.Models;
using PPDG3P.Api.Services;

namespace PPDG3P.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class TableController : ControllerBase
{
    private readonly ISqlService _sqlService;
    private readonly IMetadataService _metadataService;
    private readonly IConfiguration _configuration;

    public TableController(ISqlService sqlService, IMetadataService metadataService, IConfiguration configuration)
    {
        _sqlService = sqlService;
        _metadataService = metadataService;
        _configuration = configuration;
    }

    private string Schema => _configuration["DatabaseSchema"] ?? "ppdg3p";

    /// <summary>
    /// Get all rows from a table
    /// </summary>
    [HttpGet("{tableName}")]
    public async Task<IActionResult> GetAll(
        string tableName,
        [FromQuery] int? top = null,
        [FromQuery] int? offset = null,
        [FromQuery] string? orderBy = null,
        [FromQuery] string? orderDir = "ASC")
    {
        if (!await _metadataService.IsValidTableOrViewAsync(tableName))
            return NotFound(new { Message = $"Table '{tableName}' not found." });

        var sql = $"SELECT";

        if (top.HasValue && !offset.HasValue)
            sql += $" TOP {top.Value}";

        sql += $" * FROM [{Schema}].[{tableName}]";

        if (!string.IsNullOrEmpty(orderBy))
        {
            if (!await _metadataService.IsValidColumnAsync(tableName, orderBy))
                return BadRequest(new { Message = $"Column '{orderBy}' not found in table '{tableName}'." });

            var direction = orderDir?.ToUpper() == "DESC" ? "DESC" : "ASC";
            sql += $" ORDER BY [{orderBy}] {direction}";

            if (offset.HasValue)
            {
                sql += $" OFFSET {offset.Value} ROWS";
                if (top.HasValue)
                    sql += $" FETCH NEXT {top.Value} ROWS ONLY";
            }
        }

        var result = await _sqlService.ExecuteQueryAsync(sql);
        return Ok(result);
    }

    /// <summary>
    /// Get a single row by primary key value(s)
    /// </summary>
    [HttpGet("{tableName}/find")]
    public async Task<IActionResult> FindByKey(string tableName, [FromQuery] Dictionary<string, string> keys)
    {
        if (!await _metadataService.IsValidTableOrViewAsync(tableName))
            return NotFound(new { Message = $"Table '{tableName}' not found." });

        if (keys.Count == 0)
            return BadRequest(new { Message = "No key columns provided." });

        // Validate columns
        foreach (var key in keys.Keys)
        {
            if (!await _metadataService.IsValidColumnAsync(tableName, key))
                return BadRequest(new { Message = $"Column '{key}' not found in table '{tableName}'." });
        }

        var whereClauses = keys.Keys.Select((k, i) => $"[{k}] = @p{i}");
        var sql = $"SELECT * FROM [{Schema}].[{tableName}] WHERE {string.Join(" AND ", whereClauses)}";

        var parameters = new Dictionary<string, object?>();
        int i = 0;
        foreach (var kvp in keys)
        {
            parameters[$"p{i}"] = kvp.Value;
            i++;
        }

        var result = await _sqlService.ExecuteQueryAsync(sql, parameters);
        return Ok(result);
    }

    /// <summary>
    /// Insert a new row into a table
    /// </summary>
    [HttpPost("{tableName}")]
    public async Task<IActionResult> Insert(string tableName, [FromBody] InsertRequest request)
    {
        if (!await _metadataService.IsValidTableOrViewAsync(tableName))
            return NotFound(new { Message = $"Table '{tableName}' not found." });

        // Validate columns
        foreach (var key in request.Values.Keys)
        {
            if (!await _metadataService.IsValidColumnAsync(tableName, key))
                return BadRequest(new { Message = $"Column '{key}' not found in table '{tableName}'." });
        }

        var result = await _sqlService.ExecuteInsertAsync(tableName, request.Values);
        return CreatedAtAction(nameof(GetAll), new { tableName }, result);
    }

    /// <summary>
    /// Update an existing row in a table
    /// </summary>
    [HttpPut("{tableName}")]
    public async Task<IActionResult> Update(string tableName, [FromBody] UpdateRequest request)
    {
        if (!await _metadataService.IsValidTableOrViewAsync(tableName))
            return NotFound(new { Message = $"Table '{tableName}' not found." });

        // Validate key columns
        foreach (var key in request.Keys.Keys)
        {
            if (!await _metadataService.IsValidColumnAsync(tableName, key))
                return BadRequest(new { Message = $"Key column '{key}' not found in table '{tableName}'." });
        }

        // Validate value columns
        foreach (var key in request.Values.Keys)
        {
            if (!await _metadataService.IsValidColumnAsync(tableName, key))
                return BadRequest(new { Message = $"Column '{key}' not found in table '{tableName}'." });
        }

        var affectedRows = await _sqlService.ExecuteUpdateAsync(tableName, request.Keys, request.Values);
        return Ok(new { AffectedRows = affectedRows });
    }

    /// <summary>
    /// Delete a row from a table
    /// </summary>
    [HttpDelete("{tableName}")]
    public async Task<IActionResult> Delete(string tableName, [FromBody] DeleteRequest request)
    {
        if (!await _metadataService.IsValidTableOrViewAsync(tableName))
            return NotFound(new { Message = $"Table '{tableName}' not found." });

        // Validate key columns
        foreach (var key in request.Keys.Keys)
        {
            if (!await _metadataService.IsValidColumnAsync(tableName, key))
                return BadRequest(new { Message = $"Key column '{key}' not found in table '{tableName}'." });
        }

        var affectedRows = await _sqlService.ExecuteDeleteAsync(tableName, request.Keys);
        return Ok(new { AffectedRows = affectedRows });
    }

    /// <summary>
    /// Execute a stored procedure
    /// </summary>
    [HttpPost("procedure/{procedureName}")]
    public async Task<IActionResult> ExecuteProcedure(string procedureName, [FromBody] Dictionary<string, System.Text.Json.JsonElement>? parameters = null)
    {
        var procedures = await _metadataService.GetStoredProceduresAsync();
        if (!procedures.Contains(procedureName))
            return NotFound(new { Message = $"Stored procedure '{procedureName}' not found." });

        var result = await _sqlService.ExecuteStoredProcedureAsync(procedureName, parameters);
        return Ok(result);
    }
}
