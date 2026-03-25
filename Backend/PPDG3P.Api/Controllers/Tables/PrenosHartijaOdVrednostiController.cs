using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/PrenosHartijaOdVrednosti")]
public class PrenosHartijaOdVrednostiController : ControllerBase
{
    private readonly string _cs;
    public PrenosHartijaOdVrednostiController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[PrenosHartijaOdVrednosti]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "IDStavkePrenosa", "IDPrijave", "Naziv", "BrDokOPrenosu", "BrPrenetihHOV" }, primaryKey = new[] { "IDStavkePrenosa", "IDPrijave" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[PrenosHartijaOdVrednosti] ([IDStavkePrenosa],[IDPrijave],[Naziv],[BrDokOPrenosu],[BrPrenetihHOV]) VALUES (@IDStavke,@IDPrijave,@Naziv,@BrDok,@BrHOV)", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkePrenosa"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        cmd.Parameters.AddWithValue("@BrDok", DbHelper.Param(body, "BrDokOPrenosu"));
        cmd.Parameters.AddWithValue("@BrHOV", DbHelper.Param(body, "BrPrenetihHOV"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[PrenosHartijaOdVrednosti] SET [Naziv]=@Naziv,[BrDokOPrenosu]=@BrDok,[BrPrenetihHOV]=@BrHOV WHERE [IDStavkePrenosa]=@IDStavke AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkePrenosa"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@Naziv", DbHelper.Param(body, "Naziv"));
        cmd.Parameters.AddWithValue("@BrDok", DbHelper.Param(body, "BrDokOPrenosu"));
        cmd.Parameters.AddWithValue("@BrHOV", DbHelper.Param(body, "BrPrenetihHOV"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[PrenosHartijaOdVrednosti] WHERE [IDStavkePrenosa]=@IDStavke AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkePrenosa"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
