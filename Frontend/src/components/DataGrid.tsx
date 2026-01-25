import { useMemo } from 'react';
import type { ColumnMetadata } from '../types';
import { getColumnDisplayName } from '../types';
import './DataGrid.css';

interface DataGridProps {
  columns: ColumnMetadata[];
  data: Record<string, unknown>[];
  primaryKeyColumns: string[];
  onEdit?: (row: Record<string, unknown>) => void;
  onDelete?: (row: Record<string, unknown>) => void;
  loading?: boolean;
}

function formatCellValue(value: unknown, dataType: string): string {
  if (value === null || value === undefined) {
    return '';
  }

  if (dataType === 'bit') {
    return value ? 'Da' : 'Ne';
  }

  if (dataType === 'date' || dataType === 'datetime' || dataType === 'datetime2') {
    try {
      const date = new Date(value as string);
      return date.toLocaleDateString('sr-RS');
    } catch {
      return String(value);
    }
  }

  if (dataType === 'bigint' || dataType === 'int' || dataType === 'decimal' || dataType === 'money') {
    const num = Number(value);
    if (!isNaN(num)) {
      return num.toLocaleString('sr-RS');
    }
  }

  // Trim nchar/nvarchar values
  if (typeof value === 'string') {
    return value.trim();
  }

  return String(value);
}

export function DataGrid({
  columns,
  data,
  primaryKeyColumns,
  onEdit,
  onDelete,
  loading,
}: DataGridProps) {
  const visibleColumns = useMemo(() => {
    return columns.filter(col => !col.columnName.startsWith('_'));
  }, [columns]);

  const getRowKey = (row: Record<string, unknown>): string => {
    return primaryKeyColumns.map(pk => String(row[pk] ?? '')).join('_');
  };

  if (loading) {
    return (
      <div className="data-grid-loading">
        <div className="spinner"></div>
        <span>Učitavanje...</span>
      </div>
    );
  }

  if (data.length === 0) {
    return (
      <div className="data-grid-empty">
        <p>Nema podataka za prikaz</p>
      </div>
    );
  }

  return (
    <div className="data-grid-container">
      <table className="data-grid">
        <thead>
          <tr>
            {visibleColumns.map((col) => (
              <th key={col.columnName} title={col.columnName}>
                {getColumnDisplayName(col.columnName)}
                {col.isPrimaryKey && <span className="pk-indicator">PK</span>}
              </th>
            ))}
            {(onEdit || onDelete) && <th className="actions-column">Akcije</th>}
          </tr>
        </thead>
        <tbody>
          {data.map((row) => (
            <tr key={getRowKey(row)}>
              {visibleColumns.map((col) => (
                <td key={col.columnName} className={col.isPrimaryKey ? 'pk-cell' : ''}>
                  {formatCellValue(row[col.columnName], col.dataType)}
                </td>
              ))}
              {(onEdit || onDelete) && (
                <td className="actions-cell">
                  {onEdit && (
                    <button
                      className="action-btn edit-btn"
                      onClick={() => onEdit(row)}
                      title="Izmeni"
                    >
                      ✏️
                    </button>
                  )}
                  {onDelete && (
                    <button
                      className="action-btn delete-btn"
                      onClick={() => onDelete(row)}
                      title="Obriši"
                    >
                      🗑️
                    </button>
                  )}
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
