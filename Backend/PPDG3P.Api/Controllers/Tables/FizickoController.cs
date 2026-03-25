using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/Fizicko")]
public class FizickoController : ControllerBase
{
    private readonly string _cs;
    public FizickoController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[Fizicko]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "JMGB/ESB/PIB_lice", "Ime", "Prezime" }, primaryKey = new[] { "JMGB/ESB/PIB_lice" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[Fizicko] ([JMGB/ESB/PIB_lice],[Ime],[Prezime]) VALUES (@JMBG,@Ime,@Prezime)", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMGB/ESB/PIB_lice"));
        cmd.Parameters.AddWithValue("@Ime", DbHelper.Param(body, "Ime"));
        cmd.Parameters.AddWithValue("@Prezime", DbHelper.Param(body, "Prezime"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[Fizicko] SET [Ime]=@Ime,[Prezime]=@Prezime WHERE [JMGB/ESB/PIB_lice]=@JMBG", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMGB/ESB/PIB_lice"));
        cmd.Parameters.AddWithValue("@Ime", DbHelper.Param(body, "Ime"));
        cmd.Parameters.AddWithValue("@Prezime", DbHelper.Param(body, "Prezime"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[Fizicko] WHERE [JMGB/ESB/PIB_lice]=@JMBG", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMGB/ESB/PIB_lice"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
