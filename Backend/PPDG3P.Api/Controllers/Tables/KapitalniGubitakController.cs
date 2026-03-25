using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/KapitalniGubitak")]
public class KapitalniGubitakController : ControllerBase
{
    private readonly string _cs;
    public KapitalniGubitakController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[KapitalniGubitak]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "IDStavkeUmanjenja", "BrojResenja", "IznosKapGub", "IDPrijave" }, primaryKey = new[] { "IDStavkeUmanjenja", "BrojResenja" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[KapitalniGubitak] ([IDStavkeUmanjenja],[BrojResenja],[IznosKapGub],[IDPrijave]) VALUES (@IDStavke,@BrojResenja,@IznosKapGub,@IDPrijave)", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@BrojResenja", DbHelper.Param(body, "BrojResenja"));
        cmd.Parameters.AddWithValue("@IznosKapGub", DbHelper.Param(body, "IznosKapGub"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[KapitalniGubitak] SET [IznosKapGub]=@IznosKapGub,[IDPrijave]=@IDPrijave WHERE [IDStavkeUmanjenja]=@IDStavke AND [BrojResenja]=@BrojResenja", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@BrojResenja", DbHelper.Param(body, "BrojResenja"));
        cmd.Parameters.AddWithValue("@IznosKapGub", DbHelper.Param(body, "IznosKapGub"));
        cmd.Parameters.AddWithValue("@IDPrijave", DbHelper.Param(body, "IDPrijave"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[KapitalniGubitak] WHERE [IDStavkeUmanjenja]=@IDStavke AND [BrojResenja]=@BrojResenja", conn);
        cmd.Parameters.AddWithValue("@IDStavke", DbHelper.Param(body, "IDStavkeUmanjenja"));
        cmd.Parameters.AddWithValue("@BrojResenja", DbHelper.Param(body, "BrojResenja"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
