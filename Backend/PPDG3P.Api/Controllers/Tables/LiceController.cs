using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/Lice")]
public class LiceController : ControllerBase
{
    private readonly string _cs;
    public LiceController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[Lice]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "JMBG/ESB/PIB", "Telefon", "Adresa", "Drzava", "Email" }, primaryKey = new[] { "JMBG/ESB/PIB" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[Lice] ([JMBG/ESB/PIB],[Telefon],[Adresa],[Drzava],[Email]) VALUES (@JMBG,@Telefon,@Adresa,@Drzava,@Email)", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB"));
        cmd.Parameters.AddWithValue("@Telefon", DbHelper.Param(body, "Telefon"));
        cmd.Parameters.AddWithValue("@Adresa", DbHelper.Param(body, "Adresa"));
        cmd.Parameters.AddWithValue("@Drzava", DbHelper.Param(body, "Drzava"));
        cmd.Parameters.AddWithValue("@Email", DbHelper.Param(body, "Email"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[Lice] SET [Telefon]=@Telefon,[Adresa]=@Adresa,[Drzava]=@Drzava,[Email]=@Email WHERE [JMBG/ESB/PIB]=@JMBG", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB"));
        cmd.Parameters.AddWithValue("@Telefon", DbHelper.Param(body, "Telefon"));
        cmd.Parameters.AddWithValue("@Adresa", DbHelper.Param(body, "Adresa"));
        cmd.Parameters.AddWithValue("@Drzava", DbHelper.Param(body, "Drzava"));
        cmd.Parameters.AddWithValue("@Email", DbHelper.Param(body, "Email"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[Lice] WHERE [JMBG/ESB/PIB]=@JMBG", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
