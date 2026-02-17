import { useState, useEffect } from 'react';
import type { ColumnMetadata, ForeignKeyMetadata } from '../types';
import { getColumnDisplayName } from '../types';
import { tableApi } from '../api/client';
import './RecordForm.css';

interface RecordFormProps {
  columns: ColumnMetadata[];
  foreignKeys: ForeignKeyMetadata[];
  initialValues?: Record<string, unknown>;
  onSubmit: (values: Record<string, unknown>) => void;
  onCancel: () => void;
  isEdit?: boolean;
  loading?: boolean;
}

interface LookupData {
  [tableName: string]: Record<string, unknown>[];
}

export function RecordForm({
  columns,
  foreignKeys,
  initialValues,
  onSubmit,
  onCancel,
  isEdit = false,
  loading = false,
}: RecordFormProps) {
  const [values, setValues] = useState<Record<string, unknown>>({});
  const [lookups, setLookups] = useState<LookupData>({});
  const [loadingLookups, setLoadingLookups] = useState(false);

  // Initialize form values
  useEffect(() => {
    const initial: Record<string, unknown> = {};
    columns.forEach((col) => {
      if (initialValues && initialValues[col.columnName] !== undefined) {
        let value = initialValues[col.columnName];
        // Format date values for input
        if ((col.dataType === 'date' || col.dataType.includes('datetime')) && value) {
          const date = new Date(value as string);
          value = date.toISOString().split('T')[0];
        }
        // Trim string values
        if (typeof value === 'string') {
          value = value.trim();
        }
        initial[col.columnName] = value;
      } else {
        initial[col.columnName] = '';
      }
    });
    setValues(initial);
  }, [columns, initialValues]);

  // Load lookup data for foreign keys
  useEffect(() => {
    const loadLookups = async () => {
      const uniqueTables = [...new Set(foreignKeys.map((fk) => fk.referencedTable))];
      if (uniqueTables.length === 0) return;

      setLoadingLookups(true);
      const newLookups: LookupData = {};

      for (const table of uniqueTables) {
        try {
          const result = await tableApi.getAll(table, { top: 1000 });
          newLookups[table] = result.rows;
        } catch (err) {
          console.error(`Failed to load lookup for ${table}:`, err);
          newLookups[table] = [];
        }
      }

      setLookups(newLookups);
      setLoadingLookups(false);
    };

    loadLookups();
  }, [foreignKeys]);

  const handleChange = (columnName: string, value: unknown) => {
    setValues((prev) => ({
      ...prev,
      [columnName]: value,
    }));
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    // Convert empty strings to null, format values
    const submitValues: Record<string, unknown> = {};
    columns.forEach((col) => {
      // Skip identity columns on insert
      if (!isEdit && col.isIdentity) return;
      // Skip primary key columns on edit (they're used as keys, not values)
      if (isEdit && col.isPrimaryKey) return;

      let value = values[col.columnName];

      if (value === '' || value === undefined) {
        if (!col.isNullable && !col.isIdentity) {
          // Keep empty string for required fields - let DB decide
          submitValues[col.columnName] = '';
        } else {
          submitValues[col.columnName] = null;
        }
      } else if (col.dataType === 'bit') {
        submitValues[col.columnName] = value === 'true' || value === true;
      } else if (col.dataType === 'int' || col.dataType === 'bigint') {
        submitValues[col.columnName] = value ? Number(value) : null;
      } else {
        submitValues[col.columnName] = value;
      }
    });

    onSubmit(submitValues);
  };

  const getForeignKey = (columnName: string): ForeignKeyMetadata | undefined => {
    return foreignKeys.find((fk) => fk.columnName === columnName);
  };

  const renderInput = (col: ColumnMetadata) => {
    const fk = getForeignKey(col.columnName);
    const value = values[col.columnName] ?? '';
    const isDisabled = col.isIdentity || (isEdit && col.isPrimaryKey);

    // Foreign key - render as select
    if (fk && lookups[fk.referencedTable]) {
      const options = lookups[fk.referencedTable];
      return (
        <select
          value={String(value)}
          onChange={(e) => handleChange(col.columnName, e.target.value)}
          disabled={isDisabled || loadingLookups}
          className="form-select"
        >
          <option value="">-- Izaberite --</option>
          {options.map((opt, idx) => {
            const optKey = opt[fk.referencedColumn];
            const displayValue = getOptionDisplayText(opt);
            return (
              <option key={idx} value={String(optKey)}>
                {displayValue}
              </option>
            );
          })}
        </select>
      );
    }

    // Boolean - render as select
    if (col.dataType === 'bit') {
      return (
        <select
          value={value === true || value === 'true' ? 'true' : value === false || value === 'false' ? 'false' : ''}
          onChange={(e) => handleChange(col.columnName, e.target.value)}
          disabled={isDisabled}
          className="form-select"
        >
          <option value="">-- Izaberite --</option>
          <option value="true">Da</option>
          <option value="false">Ne</option>
        </select>
      );
    }

    // Date - render as date input
    if (col.dataType === 'date' || col.dataType.includes('datetime')) {
      return (
        <input
          type="date"
          value={String(value)}
          onChange={(e) => handleChange(col.columnName, e.target.value)}
          disabled={isDisabled}
          className="form-input"
        />
      );
    }

    // Number types
    if (['int', 'bigint', 'decimal', 'money', 'real', 'float'].includes(col.dataType)) {
      return (
        <input
          type="number"
          value={String(value)}
          onChange={(e) => handleChange(col.columnName, e.target.value)}
          disabled={isDisabled}
          className="form-input"
          step={col.dataType === 'decimal' || col.dataType === 'money' ? '0.01' : '1'}
        />
      );
    }

    // Default - text input
    return (
      <input
        type="text"
        value={String(value)}
        onChange={(e) => handleChange(col.columnName, e.target.value)}
        disabled={isDisabled}
        className="form-input"
      />
    );
  };

  return (
    <form className="record-form" onSubmit={handleSubmit}>
      <div className="form-grid">
        {columns.map((col) => (
          <div key={col.columnName} className="form-field">
            <label className="form-label">
              {getColumnDisplayName(col.columnName)}
              {!col.isNullable && !col.isIdentity && <span className="required">*</span>}
              {col.isPrimaryKey && <span className="pk-badge">PK</span>}
              {col.isIdentity && <span className="identity-badge">Auto</span>}
            </label>
            {renderInput(col)}
            <span className="field-hint">
              {col.dataType}
              {col.maxLength && ` (${col.maxLength})`}
            </span>
          </div>
        ))}
      </div>

      <div className="form-actions">
        <button type="button" className="btn btn-secondary" onClick={onCancel} disabled={loading}>
          Otkaži
        </button>
        <button type="submit" className="btn btn-primary" disabled={loading}>
          {loading ? 'Čuvanje...' : isEdit ? 'Sačuvaj izmene' : 'Dodaj'}
        </button>
      </div>
    </form>
  );
}

// Helper to get display text for lookup options
function getOptionDisplayText(row: Record<string, unknown>): string {
  // Try common display columns
  const displayColumns = ['Naziv', 'Ime', 'Name', 'Title', 'Email'];
  for (const col of displayColumns) {
    if (row[col]) {
      const value = String(row[col]).trim();
      // Include ID for clarity
      const idCols = Object.keys(row).filter(k => k === 'ID' || k.includes('JMBG') || k.includes('PIB'));
      if (idCols.length > 0) {
        return `${row[idCols[0]]} - ${value}`;
      }
      return value;
    }
  }
  // Fallback - show first few values
  const values = Object.values(row).slice(0, 2).map(v => String(v).trim()).join(' - ');
  return values;
}
