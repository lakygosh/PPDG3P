using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/StavkaPrenosa")]
public class StavkaPrenosController : ControllerBase
{
    private readonly string _cs;
    public StavkaPrenosController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[StavkaPrenosa]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "ID", "IDPrijave", "NabavnaCena", "DatumPrenosa", "ProdajnaCena", "DatumSticanja", "PrenosPravaUdelaDigImov" }, primaryKey = new[] { "ID", "IDPrijave" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[StavkaPrenosa] ([IDPrijave],[NabavnaCena],[DatumPrenosa],[ProdajnaCena],[DatumSticanja],[PrenosPravaUdelaDigImov]) VALUES (@IDPrijave,@NabavnaCena,@DatumPrenosa,@ProdajnaCena,@DatumSticanja,@PrenosPrava)", conn);
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@NabavnaCena", DbHelper.Param(body, "NabavnaCena"));
        cmd.Parameters.AddWithValue("@DatumPrenosa", DbHelper.Param(body, "DatumPrenosa"));
        cmd.Parameters.AddWithValue("@ProdajnaCena", DbHelper.Param(body, "ProdajnaCena"));
        cmd.Parameters.AddWithValue("@DatumSticanja", DbHelper.Param(body, "DatumSticanja"));
        cmd.Parameters.AddWithValue("@PrenosPrava", DbHelper.Param(body, "PrenosPravaUdelaDigImov"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[StavkaPrenosa] SET [NabavnaCena]=@NabavnaCena,[DatumPrenosa]=@DatumPrenosa,[ProdajnaCena]=@ProdajnaCena,[DatumSticanja]=@DatumSticanja,[PrenosPravaUdelaDigImov]=@PrenosPrava WHERE [ID]=@ID AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@NabavnaCena", DbHelper.Param(body, "NabavnaCena"));
        cmd.Parameters.AddWithValue("@DatumPrenosa", DbHelper.Param(body, "DatumPrenosa"));
        cmd.Parameters.AddWithValue("@ProdajnaCena", DbHelper.Param(body, "ProdajnaCena"));
        cmd.Parameters.AddWithValue("@DatumSticanja", DbHelper.Param(body, "DatumSticanja"));
        cmd.Parameters.AddWithValue("@PrenosPrava", DbHelper.Param(body, "PrenosPravaUdelaDigImov"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[StavkaPrenosa] WHERE [ID]=@ID AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
