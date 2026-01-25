using System.Text.Json;
using PPDG3P.Api.Models;

namespace PPDG3P.Api.Services;

public interface ISqlService
{
    Task<QueryResult> ExecuteQueryAsync(string sql, Dictionary<string, object?>? parameters = null);
    Task<InsertResult> ExecuteInsertAsync(string tableName, Dictionary<string, JsonElement> values);
    Task<int> ExecuteUpdateAsync(string tableName, Dictionary<string, JsonElement> keys, Dictionary<string, JsonElement> values);
    Task<int> ExecuteDeleteAsync(string tableName, Dictionary<string, JsonElement> keys);
    Task<int> ExecuteNonQueryAsync(string sql, Dictionary<string, object?>? parameters = null);
    Task<QueryResult> ExecuteStoredProcedureAsync(string procedureName, Dictionary<string, JsonElement>? parameters = null);
}
