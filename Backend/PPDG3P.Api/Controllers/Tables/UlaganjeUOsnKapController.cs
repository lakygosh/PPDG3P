using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/UlaganjeUOsnKap")]
public class UlaganjeUOsnKapController : ControllerBase
{
    private readonly string _cs;
    public UlaganjeUOsnKapController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[UlaganjeUOsnKap]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "IDStavkeUmanjenja", "IznosUlozenUKapDP", "IznosUlozenUKapIF" }, primaryKey = new[] { "IDStavkeUmanjenja" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[UlaganjeUOsnKap] ([IDStavkeUmanjenja],[IznosUlozenUKapDP],[IznosUlozenUKapIF]) VALUES (@IDStavke,@IznosDP,@IznosIF)", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@IznosDP", DbHelper.Param(body, "IznosUlozenUKapDP"));
        cmd.Parameters.AddWithValue("@IznosIF", DbHelper.Param(body, "IznosUlozenUKapIF"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[UlaganjeUOsnKap] SET [IznosUlozenUKapDP]=@IznosDP,[IznosUlozenUKapIF]=@IznosIF WHERE [IDStavkeUmanjenja]=@IDStavke", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@IznosDP", DbHelper.Param(body, "IznosUlozenUKapDP"));
        cmd.Parameters.AddWithValue("@IznosIF", DbHelper.Param(body, "IznosUlozenUKapIF"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[UlaganjeUOsnKap] WHERE [IDStavkeUmanjenja]=@IDStavke", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
