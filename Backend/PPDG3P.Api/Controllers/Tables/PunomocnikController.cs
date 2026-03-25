using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/Punomocnik")]
public class PunomocnikController : ControllerBase
{
    private readonly string _cs;
    public PunomocnikController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[Punomocnik]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "JMBG/ESB/PIB_lice", "IDPrijave", "Naziv", "JMBG/ESB/PIB_pun" }, primaryKey = new[] { "JMBG/ESB/PIB_lice", "IDPrijave" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[Punomocnik] ([IDPrijave],[Naziv],[JMBG/ESB/PIB_pun]) VALUES (@IDPrijave,@Naziv,@JMBGPun)", conn);
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        cmd.Parameters.AddWithValue("@JMBGPun", DbHelper.Param(body, "JMBG/ESB/PIB_pun"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[Punomocnik] SET [Naziv]=@Naziv,[JMBG/ESB/PIB_pun]=@JMBGPun WHERE [JMBG/ESB/PIB_lice]=@JMBG AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB_lice"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        cmd.Parameters.AddWithValue("@JMBGPun", DbHelper.Param(body, "JMBG/ESB/PIB_pun"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[Punomocnik] WHERE [JMBG/ESB/PIB_lice]=@JMBG AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB_lice"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
