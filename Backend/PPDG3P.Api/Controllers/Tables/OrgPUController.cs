using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/OrgPU")]
public class OrgPUController : ControllerBase
{
    private readonly string _cs;
    public OrgPUController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[OrgPU]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "ID", "Naziv" }, primaryKey = new[] { "ID" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[OrgPU] ([Naziv]) VALUES (@Naziv)", conn);
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[OrgPU] SET [Naziv]=@Naziv WHERE [ID]=@ID", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[OrgPU] WHERE [ID]=@ID", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
