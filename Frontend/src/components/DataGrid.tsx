import { getColumnDisplayName } from '../types';
import './DataGrid.css';

interface DataGridProps {
  columns: string[];
  data: Record<string, unknown>[];
  primaryKeyColumns: string[];
  onEdit?: (row: Record<string, unknown>) => void;
  onDelete?: (row: Record<string, unknown>) => void;
  loading?: boolean;
}

function formatCellValue(value: unknown): string {
  if (value === null || value === undefined) {
    return '';
  }

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
            {columns.map((col) => (
              <th key={col} title={col}>
                {getColumnDisplayName(col)}
              </th>
            ))}
            {(onEdit || onDelete) && <th className="actions-column">Akcije</th>}
          </tr>
        </thead>
        <tbody>
          {data.map((row) => (
            <tr key={getRowKey(row)}>
              {columns.map((col) => (
                <td key={col}>
                  {formatCellValue(row[col])}
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
