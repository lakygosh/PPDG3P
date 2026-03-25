using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/DokumentOSticanju")]
public class DokumentOSticanjuController : ControllerBase
{
    private readonly string _cs;
    public DokumentOSticanjuController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[DokumentOSticanju]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "ID", "BrojStecenihJedinica", "IDPrenHartVred", "IDPrijave", "DatumSticanja", "NabavnaCena" }, primaryKey = new[] { "ID" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[DokumentOSticanju] ([ID],[BrojStecenihJedinica],[IDPrenHartVred],[IDPrijave],[DatumSticanja],[NabavnaCena]) VALUES (@ID,@BrojStecenih,@IDPrenHart,@IDPrijave,@DatumSticanja,@NabavnaCena)", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@BrojStecenih", DbHelper.Param(body, "BrojStecenihJedinica"));
        cmd.Parameters.AddWithValue("@IDPrenHart", DbHelper.Param(body, "IDPrenHartVred"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@DatumSticanja", DbHelper.Param(body, "DatumSticanja"));
        cmd.Parameters.AddWithValue("@NabavnaCena", DbHelper.Param(body, "NabavnaCena"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[DokumentOSticanju] SET [BrojStecenihJedinica]=@BrojStecenih,[IDPrenHartVred]=@IDPrenHart,[IDPrijave]=@IDPrijave,[DatumSticanja]=@DatumSticanja,[NabavnaCena]=@NabavnaCena WHERE [ID]=@ID", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@BrojStecenih", DbHelper.Param(body, "BrojStecenihJedinica"));
        cmd.Parameters.AddWithValue("@IDPrenHart", DbHelper.Param(body, "IDPrenHartVred"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@DatumSticanja", DbHelper.Param(body, "DatumSticanja"));
        cmd.Parameters.AddWithValue("@NabavnaCena", DbHelper.Param(body, "NabavnaCena"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[DokumentOSticanju] WHERE [ID]=@ID", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
