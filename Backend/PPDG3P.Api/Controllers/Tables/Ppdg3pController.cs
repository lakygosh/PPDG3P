using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/PPDG3P")]
public class Ppdg3pController : ControllerBase
{
    private readonly string _cs;
    public Ppdg3pController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[PPDG3P]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "ID", "IDPoreskogObveznika", "UkProdajnaCena", "UkNabavnaCena", "UkUmanjenja", "KapitalnaOsnovica", "Email_lice" }, primaryKey = new[] { "ID" }, excludableColumns = new[] { "IDPoreskogObveznika" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[PPDG3P] ([IDPoreskogObveznika],[UkProdajnaCena],[UkNabavnaCena],[UkUmanjenja],[KapitalnaOsnovica],[Email_lice]) VALUES (@IDPoreskogObveznika,@UkProdajnaCena,@UkNabavnaCena,@UkUmanjenja,@KapitalnaOsnovica,@Email_lice)", conn);
        cmd.Parameters.AddWithValue("@IDPoreskogObveznika", DbHelper.Param(body, "IDPoreskogObveznika"));
        cmd.Parameters.AddWithValue("@UkProdajnaCena", DbHelper.Param(body, "UkProdajnaCena"));
        cmd.Parameters.AddWithValue("@UkNabavnaCena", DbHelper.Param(body, "UkNabavnaCena"));
        cmd.Parameters.AddWithValue("@UkUmanjenja", DbHelper.Param(body, "UkUmanjenja"));
        cmd.Parameters.AddWithValue("@KapitalnaOsnovica", DbHelper.Param(body, "KapitalnaOsnovica"));
        cmd.Parameters.AddWithValue("@Email_lice", DbHelper.Param(body, "Email_lice"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();

        bool includeObveznik = !DbHelper.IsExcluded(body, "IDPoreskogObveznika");

        var setClauses = new List<string> { "[UkProdajnaCena]=@UkProdajnaCena", "[UkNabavnaCena]=@UkNabavnaCena", "[UkUmanjenja]=@UkUmanjenja", "[KapitalnaOsnovica]=@KapitalnaOsnovica", "[Email_lice]=@Email_lice" };
        if (includeObveznik)
            setClauses.Insert(0, "[IDPoreskogObveznika]=@IDPoreskogObveznika");

        var sql = $"UPDATE [ppdg3p].[PPDG3P] SET {string.Join(",", setClauses)} WHERE [ID]=@ID";

        using var cmd = new SqlCommand(sql, conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        if (includeObveznik)
            cmd.Parameters.AddWithValue("@IDPoreskogObveznika", DbHelper.Param(body, "IDPoreskogObveznika"));
        cmd.Parameters.AddWithValue("@UkProdajnaCena", DbHelper.Param(body, "UkProdajnaCena"));
        cmd.Parameters.AddWithValue("@UkNabavnaCena", DbHelper.Param(body, "UkNabavnaCena"));
        cmd.Parameters.AddWithValue("@UkUmanjenja", DbHelper.Param(body, "UkUmanjenja"));
        cmd.Parameters.AddWithValue("@KapitalnaOsnovica", DbHelper.Param(body, "KapitalnaOsnovica"));
        cmd.Parameters.AddWithValue("@Email_lice", DbHelper.Param(body, "Email_lice"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[PPDG3P] WHERE [ID]=@ID", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
