using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/PoreskiObveznik")]
public class PoreskiObveznikController : ControllerBase
{
    private readonly string _cs;
    public PoreskiObveznikController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[PoreskiObveznik]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "JMBG/ESB/PIB_lice", "Ime", "Prezime", "PrebivalisteOstvPrih" }, primaryKey = new[] { "JMBG/ESB/PIB_lice" }, excludableColumns = new[] { "JMBG/ESB/PIB_lice" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[PoreskiObveznik] ([JMBG/ESB/PIB_lice],[Ime],[Prezime],[PrebivalisteOstvPrih]) VALUES (@JMBG,@Ime,@Prezime,@Prebivaliste)", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB_lice"));
        cmd.Parameters.AddWithValue("@Ime", DbHelper.Param(body, "Ime"));
        cmd.Parameters.AddWithValue("@Prezime", DbHelper.Param(body, "Prezime"));
        cmd.Parameters.AddWithValue("@Prebivaliste", DbHelper.Param(body, "PrebivalisteOstvPrih"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();

        bool includeJmbg = !DbHelper.IsExcluded(body, "JMBG/ESB/PIB_lice");
        var origJmbg = DbHelper.Param(body, "_original_JMBG/ESB/PIB_lice");
        var jmbgForWhere = origJmbg is DBNull ? DbHelper.Param(body, "JMBG/ESB/PIB_lice") : origJmbg;

        var sql = includeJmbg
            ? "UPDATE [ppdg3p].[PoreskiObveznik] SET [JMBG/ESB/PIB_lice]=@JMBG,[Ime]=@Ime,[Prezime]=@Prezime,[PrebivalisteOstvPrih]=@Prebivaliste WHERE [JMBG/ESB/PIB_lice]=@OrigJMBG"
            : "UPDATE [ppdg3p].[PoreskiObveznik] SET [Ime]=@Ime,[Prezime]=@Prezime,[PrebivalisteOstvPrih]=@Prebivaliste WHERE [JMBG/ESB/PIB_lice]=@OrigJMBG";

        using var cmd = new SqlCommand(sql, conn);
        cmd.Parameters.AddWithValue("@OrigJMBG", jmbgForWhere);
        if (includeJmbg)
            cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB_lice"));
        cmd.Parameters.AddWithValue("@Ime", DbHelper.Param(body, "Ime"));
        cmd.Parameters.AddWithValue("@Prezime", DbHelper.Param(body, "Prezime"));
        cmd.Parameters.AddWithValue("@Prebivaliste", DbHelper.Param(body, "PrebivalisteOstvPrih"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[PoreskiObveznik] WHERE [JMBG/ESB/PIB_lice]=@JMBG", conn);
        cmd.Parameters.AddWithValue("@JMBG", DbHelper.Param(body, "JMBG/ESB/PIB_lice"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
