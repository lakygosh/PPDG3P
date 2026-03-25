using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Text.Json;
using PPDG3P.Api.Helpers;

namespace PPDG3P.Api.Controllers.Tables;

[ApiController]
[Route("api/tables/PPDG3P_Details")]
public class Ppdg3pDetailsController : ControllerBase
{
    private readonly string _cs;
    public Ppdg3pDetailsController(IConfiguration c) => _cs = c.GetConnectionString("DefaultConnection")!;

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand("SELECT * FROM [ppdg3p].[PPDG3P_Details]", conn);
        var rows = await DbHelper.ReadAllAsync(cmd);
        return Ok(new { rows, columns = new[] { "ID", "DatumOstvarivanjaPrihoda", "DatumDospelostiZaPodnosenjePrijave", "DatumNacinPodnosenjaPrijave", "Izmena", "IDOrganaPoreske", "IDVrstePrijave", "IDOsnovaZaPrijavu" }, primaryKey = new[] { "ID" } });
    }

    [HttpPost]
    public async Task<IActionResult> Insert([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "INSERT INTO [ppdg3p].[PPDG3P_Details] ([ID],[DatumOstvarivanjaPrihoda],[DatumDospelostiZaPodnosenjePrijave],[DatumNacinPodnosenjaPrijave],[Izmena],[IDOrganaPoreske],[IDVrstePrijave],[IDOsnovaZaPrijavu]) VALUES (@ID,@DatumOst,@DatumDos,@DatumPod,@Izmena,@IDOrg,@IDVrste,@IDOsnova)", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@DatumOst", DbHelper.Param(body, "DatumOstvarivanjaPrihoda"));
        cmd.Parameters.AddWithValue("@DatumDos", DbHelper.Param(body, "DatumDospelostiZaPodnosenjePrijave"));
        cmd.Parameters.AddWithValue("@DatumPod", DbHelper.Param(body, "DatumNacinPodnosenjaPrijave"));
        cmd.Parameters.AddWithValue("@Izmena", DbHelper.Param(body, "Izmena"));
        cmd.Parameters.AddWithValue("@IDOrg", DbHelper.Param(body, "IDOrganaPoreske"));
        cmd.Parameters.AddWithValue("@IDVrste", DbHelper.Param(body, "IDVrstePrijave"));
        cmd.Parameters.AddWithValue("@IDOsnova", DbHelper.Param(body, "IDOsnovaZaPrijavu"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpPut]
    public async Task<IActionResult> Update([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "UPDATE [ppdg3p].[PPDG3P_Details] SET [DatumOstvarivanjaPrihoda]=@DatumOst,[DatumDospelostiZaPodnosenjePrijave]=@DatumDos,[DatumNacinPodnosenjaPrijave]=@DatumPod,[Izmena]=@Izmena,[IDOrganaPoreske]=@IDOrg,[IDVrstePrijave]=@IDVrste,[IDOsnovaZaPrijavu]=@IDOsnova WHERE [ID]=@ID", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        cmd.Parameters.AddWithValue("@DatumOst", DbHelper.Param(body, "DatumOstvarivanjaPrihoda"));
        cmd.Parameters.AddWithValue("@DatumDos", DbHelper.Param(body, "DatumDospelostiZaPodnosenjePrijave"));
        cmd.Parameters.AddWithValue("@DatumPod", DbHelper.Param(body, "DatumNacinPodnosenjaPrijave"));
        cmd.Parameters.AddWithValue("@Izmena", DbHelper.Param(body, "Izmena"));
        cmd.Parameters.AddWithValue("@IDOrg", DbHelper.Param(body, "IDOrganaPoreske"));
        cmd.Parameters.AddWithValue("@IDVrste", DbHelper.Param(body, "IDVrstePrijave"));
        cmd.Parameters.AddWithValue("@IDOsnova", DbHelper.Param(body, "IDOsnovaZaPrijavu"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }

    [HttpDelete]
    public async Task<IActionResult> Delete([FromBody] JsonElement body)
    {
        using var conn = new SqlConnection(_cs);
        await conn.OpenAsync();
        using var cmd = new SqlCommand(
            "DELETE FROM [ppdg3p].[PPDG3P_Details] WHERE [ID]=@ID", conn);
        cmd.Parameters.AddWithValue("@ID", DbHelper.Param(body, "ID"));
        await cmd.ExecuteNonQueryAsync();
        return Ok();
    }
}
