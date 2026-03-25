using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/Broker")]
public class BrokerController : ControllerBase
{
    private readonly string _cs;
    public BrokerController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[Broker]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "JMGB/ESB/PIB_lice", "Naziv" }, primaryKey = new[] { "JMGB/ESB/PIB_lice" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[Broker] ([JMGB/ESB/PIB_lice],[Naziv]) VALUES (@JMBG,@Naziv)", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMGB/ESB/PIB_lice"));
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
            "UPDATE [ppdg3p].[Broker] SET [Naziv]=@Naziv WHERE [JMGB/ESB/PIB_lice]=@JMBG", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMGB/ESB/PIB_lice"));
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
            "DELETE FROM [ppdg3p].[Broker] WHERE [JMGB/ESB/PIB_lice]=@JMBG", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMGB/ESB/PIB_lice"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
