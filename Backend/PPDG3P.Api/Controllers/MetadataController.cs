using Microsoft.AspNetCore.Mvc;
using PPDG3P.Api.Services;

namespace PPDG3P.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MetadataController : ControllerBase
{
    private readonly IMetadataService _metadataService;

    public MetadataController(IMetadataService metadataService)
    {
        _metadataService = metadataService;
    }

    /// <summary>
    /// Get list of all tables with their metadata
    /// </summary>
    [HttpGet("tables")]
    public async Task<IActionResult> GetTables()
    {
        var tables = await _metadataService.GetAllTablesAsync();
        return Ok(tables);
    }

    /// <summary>
    /// Get list of all views with their metadata
    /// </summary>
    [HttpGet("views")]
    public async Task<IActionResult> GetViews()
    {
        var views = await _metadataService.GetAllViewsAsync();
        return Ok(views);
    }

    /// <summary>
    /// Get metadata for a specific table or view
    /// </summary>
    [HttpGet("tables/{tableName}")]
    public async Task<IActionResult> GetTableMetadata(string tableName)
    {
        var metadata = await _metadataService.GetTableMetadataAsync(tableName);

        if (metadata == null)
            return NotFound(new { Message = $"Table or view '{tableName}' not found." });

        return Ok(metadata);
    }

    /// <summary>
    /// Get list of available stored procedures
    /// </summary>
    [HttpGet("procedures")]
    public async Task<IActionResult> GetProcedures()
    {
        var procedures = await _metadataService.GetStoredProceduresAsync();
        return Ok(procedures);
    }
}
