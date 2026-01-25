namespace PPDG3P.Api.Models;

public class TableMetadata
{
    public string SchemaName { get; set; } = string.Empty;
    public string TableName { get; set; } = string.Empty;
    public string TableType { get; set; } = string.Empty; // "BASE TABLE" or "VIEW"
    public List<ColumnMetadata> Columns { get; set; } = new();
    public List<ForeignKeyMetadata> ForeignKeys { get; set; } = new();
    public List<string> PrimaryKeyColumns { get; set; } = new();
}

public class ColumnMetadata
{
    public string ColumnName { get; set; } = string.Empty;
    public string DataType { get; set; } = string.Empty;
    public int? MaxLength { get; set; }
    public int? NumericPrecision { get; set; }
    public int? NumericScale { get; set; }
    public bool IsNullable { get; set; }
    public bool IsIdentity { get; set; }
    public bool IsPrimaryKey { get; set; }
    public string? DefaultValue { get; set; }
    public int OrdinalPosition { get; set; }
}

public class ForeignKeyMetadata
{
    public string ConstraintName { get; set; } = string.Empty;
    public string ColumnName { get; set; } = string.Empty;
    public string ReferencedSchema { get; set; } = string.Empty;
    public string ReferencedTable { get; set; } = string.Empty;
    public string ReferencedColumn { get; set; } = string.Empty;
    public string DeleteRule { get; set; } = string.Empty;
    public string UpdateRule { get; set; } = string.Empty;
}
