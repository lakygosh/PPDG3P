using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/UlaganjneUResavanjeSP")]
public class UlaganjneUResavanjeSPController : ControllerBase
{
    private readonly string _cs;
    public UlaganjneUResavanjeSPController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[UlaganjneUResavanjeSP]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "IDStavkeUmanjenja", "IDPrijave", "IznosUlozenihSredstava", "PovrsinaZaOslobadjanje", "Domacinstvo" }, primaryKey = new[] { "IDStavkeUmanjenja", "IDPrijave" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[UlaganjneUResavanjeSP] ([IDStavkeUmanjenja],[IDPrijave],[IznosUlozenihSredstava],[PovrsinaZaOslobadjanje],[Domacinstvo]) VALUES (@IDStavke,@IDPrijave,@Iznos,@Povrsina,@Domacinstvo)", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@Iznos", DbHelper.Param(body, "IznosUlozenihSredstava"));
        cmd.Parameters.AddWithValue("@Povrsina", DbHelper.Param(body, "PovrsinaZaOslobadjanje"));
        cmd.Parameters.AddWithValue("@Domacinstvo", DbHelper.Param(body, "Domacinstvo"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[UlaganjneUResavanjeSP] SET [IznosUlozenihSredstava]=@Iznos,[PovrsinaZaOslobadjanje]=@Povrsina,[Domacinstvo]=@Domacinstvo WHERE [IDStavkeUmanjenja]=@IDStavke AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@Iznos", DbHelper.Param(body, "IznosUlozenihSredstava"));
        cmd.Parameters.AddWithValue("@Povrsina", DbHelper.Param(body, "PovrsinaZaOslobadjanje"));
        cmd.Parameters.AddWithValue("@Domacinstvo", DbHelper.Param(body, "Domacinstvo"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[UlaganjneUResavanjeSP] WHERE [IDStavkeUmanjenja]=@IDStavke AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
