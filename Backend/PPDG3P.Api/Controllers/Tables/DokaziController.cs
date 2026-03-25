using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/Dokazi")]
public class DokaziController : ControllerBase
{
    private readonly string _cs;
    public DokaziController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[Dokazi]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "BrojDokaza", "Naziv", "LokacijaFajla", "IDPrijave", "JMBG/ESB/PIB_po" }, primaryKey = new[] { "BrojDokaza" }, excludableColumns = new[] { "JMBG/ESB/PIB_po" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[Dokazi] ([Naziv],[LokacijaFajla],[IDPrijave],[JMBG/ESB/PIB_po]) VALUES (@Naziv,@Lokacija,@IDPrijave,@JMBG)", conn);
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        cmd.Parameters.AddWithValue("@Lokacija", DbHelper.Param(body, "LokacijaFajla"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB_po"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();

        bool includeJmbg = !DbHelper.IsExcluded(body, "JMBG/ESB/PIB_po");

        var sql = includeJmbg
            ? "UPDATE [ppdg3p].[Dokazi] SET [Naziv]=@Naziv,[LokacijaFajla]=@Lokacija,[IDPrijave]=@IDPrijave,[JMBG/ESB/PIB_po]=@JMBG WHERE [BrojDokaza]=@BrojDokaza"
            : "UPDATE [ppdg3p].[Dokazi] SET [Naziv]=@Naziv,[LokacijaFajla]=@Lokacija,[IDPrijave]=@IDPrijave WHERE [BrojDokaza]=@BrojDokaza";

        using var cmd = new SqlCommand(sql, conn);
        cmd.Parameters.AddWithValue("@BrojDokaza", DbHelper.Param(body, "BrojDokaza"));
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        cmd.Parameters.AddWithValue("@Lokacija", DbHelper.Param(body, "LokacijaFajla"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        if (includeJmbg)
            cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB_po"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[Dokazi] WHERE [BrojDokaza]=@BrojDokaza", conn);
        cmd.Parameters.AddWithValue("@BrojDokaza", DbHelper.Param(body, "BrojDokaza"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
