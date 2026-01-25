using PPDG3P.Api.Models;

namespace PPDG3P.Api.Services;

public interface IMetadataService
{
    Task<List<TableMetadata>> GetAllTablesAsync();
    Task<List<TableMetadata>> GetAllViewsAsync();
    Task<TableMetadata?> GetTableMetadataAsync(string tableName);
    Task<bool> IsValidTableOrViewAsync(string name);
    Task<bool> IsValidColumnAsync(string tableName, string columnName);
    Task<List<string>> GetStoredProceduresAsync();
}
