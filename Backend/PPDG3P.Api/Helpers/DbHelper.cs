using Microsoft.Data.SqlClient;
using System.Text.Json;

namespace PPDG3P.Api.Helpers;

public static class DbHelper
{
    public static async Task<List<Dictionary<string, object?>>> ReadAllAsync(SqlCommand cmd)
    {
        var rows = new List<Dictionary<string, object?>>();
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            var row = new Dictionary<string, object?>();
            for (int i = 0; i < reader.FieldCount; i++)
                row[reader.GetName(i)] = reader.IsDBNull(i) ? null : reader.GetValue(i);
            rows.Add(row);
        }
        return rows;
    }

    public static bool IsExcluded(JsonElement body, string columnName)
    {
        if (body.TryGetProperty("_excluded", out var arr) && arr.ValueKind == JsonValueKind.Array)
        {
            foreach (var item in arr.EnumerateArray())
            {
                if (item.GetString() == columnName)
                    return true;
            }
        }
        return false;
    }

    public static object Param(JsonElement body, string name)
    {
        if (!body.TryGetProperty(name, out var el) ||
            el.ValueKind == JsonValueKind.Null ||
            el.ValueKind == JsonValueKind.Undefined ||
            (el.ValueKind == JsonValueKind.String && string.IsNullOrEmpty(el.GetString())))
            return DBNull.Value;
        return el.ToString();
    }
}
