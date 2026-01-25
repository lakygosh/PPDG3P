namespace PPDG3P.Api.Models;

public class SqlErrorResponse
{
    public int ErrorNumber { get; set; }
    public string Message { get; set; } = string.Empty;
    public string? Procedure { get; set; }
    public int LineNumber { get; set; }
    public byte State { get; set; }
    public byte Class { get; set; }
    public string? Server { get; set; }
}
