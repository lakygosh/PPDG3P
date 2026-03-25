using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/StavkaUmanjenja")]
public class StavkaUmanjenjaController : ControllerBase
{
    private readonly string _cs;
    public StavkaUmanjenjaController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[StavkaUmanjenja]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "ID", "IDPrijave", "DatumUlaganja" }, primaryKey = new[] { "ID", "IDPrijave" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[StavkaUmanjenja] ([IDPrijave],[DatumUlaganja]) VALUES (@IDPrijave,@DatumUlaganja)", conn);
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@DatumUlaganja", DbHelper.Param(body, "DatumUlaganja"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[StavkaUmanjenja] SET [DatumUlaganja]=@DatumUlaganja WHERE [ID]=@ID AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        cmd.Parameters.AddWithValue("@DatumUlaganja", DbHelper.Param(body, "DatumUlaganja"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[StavkaUmanjenja] WHERE [ID]=@ID AND [IDPrijave]=@IDPrijave", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
