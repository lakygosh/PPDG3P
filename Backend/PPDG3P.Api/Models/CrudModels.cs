using System.Text.Json;

namespace PPDG3P.Api.Models;

public class InsertRequest
{
    public Dictionary<string, JsonElement> Values { get; set; } = new();
}

public class UpdateRequest
{
    public Dictionary<string, JsonElement> Keys { get; set; } = new();
    public Dictionary<string, JsonElement> Values { get; set; } = new();
}

public class DeleteRequest
{
    public Dictionary<string, JsonElement> Keys { get; set; } = new();
}

public class QueryResult
{
    public List<Dictionary<string, object?>> Rows { get; set; } = new();
    public int TotalCount { get; set; }
    public int AffectedRows { get; set; }
}

public class InsertResult
{
    public int AffectedRows { get; set; }
    public Dictionary<string, object?>? InsertedRow { get; set; }
}

public class StoredProcedureRequest
{
    public string ProcedureName { get; set; } = string.Empty;
    public Dictionary<string, JsonElement>? Parameters { get; set; }
}
