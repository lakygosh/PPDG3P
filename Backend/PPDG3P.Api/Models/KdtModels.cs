using System.Text.Json;

namespace PPDG3P.Api.Models;

/// <summary>
/// Request model for KDT (table-per-subtype) insert operations.
/// Allows inserting into parent and child tables in a single request.
/// </summary>
public class KdtInsertRequest
{
    /// <summary>
    /// Values for the parent (base) table
    /// </summary>
    public Dictionary<string, JsonElement> ParentValues { get; set; } = new();

    /// <summary>
    /// Values for the child (specialization) table
    /// </summary>
    public Dictionary<string, JsonElement> ChildValues { get; set; } = new();
}

/// <summary>
/// Request model for KDT update operations
/// </summary>
public class KdtUpdateRequest
{
    /// <summary>
    /// Key values to identify the record (usually the shared primary key)
    /// </summary>
    public Dictionary<string, JsonElement> Keys { get; set; } = new();

    /// <summary>
    /// Values to update in the parent table
    /// </summary>
    public Dictionary<string, JsonElement> ParentValues { get; set; } = new();

    /// <summary>
    /// Values to update in the child table
    /// </summary>
    public Dictionary<string, JsonElement> ChildValues { get; set; } = new();
}

/// <summary>
/// Defines a KDT (table-per-subtype) hierarchy
/// </summary>
public class KdtHierarchy
{
    public string Name { get; set; } = string.Empty;
    public string ParentTable { get; set; } = string.Empty;
    public string ParentKeyColumn { get; set; } = string.Empty;
    public List<KdtChildTable> ChildTables { get; set; } = new();
}

public class KdtChildTable
{
    public string TableName { get; set; } = string.Empty;
    public string ForeignKeyColumn { get; set; } = string.Empty;
    public string TypeDiscriminator { get; set; } = string.Empty;
}
