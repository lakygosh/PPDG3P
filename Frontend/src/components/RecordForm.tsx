import { useState, useEffect } from 'react';
import { getColumnDisplayName } from '../types';
import './RecordForm.css';

interface RecordFormProps {
  columns: string[];
  initialValues?: Record<string, unknown>;
  onSubmit: (values: Record<string, unknown>) => void;
  onCancel: () => void;
  isEdit?: boolean;
  loading?: boolean;
  excludableColumns?: string[];
}

export function RecordForm({
  columns,
  initialValues,
  onSubmit,
  onCancel,
  isEdit = false,
  loading = false,
  excludableColumns = [],
}: RecordFormProps) {
  const [values, setValues] = useState<Record<string, unknown>>({});
  const [excluded, setExcluded] = useState<Set<string>>(new Set());

  useEffect(() => {
    const initial: Record<string, unknown> = {};
    columns.forEach((col) => {
      if (initialValues && initialValues[col] !== undefined) {
        let value = initialValues[col];
        if (typeof value === 'string') {
          value = value.trim();
        }
        initial[col] = value;
      } else {
        initial[col] = '';
      }
    });
    setValues(initial);
    // By default, excludable columns start excluded (unchecked)
    if (isEdit) {
      setExcluded(new Set(excludableColumns));
    }
  }, [columns, initialValues, isEdit, excludableColumns]);

  const handleChange = (columnName: string, value: string) => {
    setValues((prev) => ({
      ...prev,
      [columnName]: value,
    }));
  };

  const toggleExcluded = (col: string) => {
    setExcluded((prev) => {
      const next = new Set(prev);
      if (next.has(col)) {
        next.delete(col);
      } else {
        next.add(col);
      }
      return next;
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();

    const submitValues: Record<string, unknown> = {};
    columns.forEach((col) => {
      const value = values[col];
      if (value === '' || value === undefined) {
        submitValues[col] = null;
      } else {
        submitValues[col] = value;
      }
    });

    // Add excluded columns list
    if (excluded.size > 0) {
      submitValues['_excluded'] = Array.from(excluded);
    }

    onSubmit(submitValues);
  };

  const isExcludable = (col: string) => isEdit && excludableColumns.includes(col);

  return (
    <form className="record-form" onSubmit={handleSubmit}>
      <div className="form-grid">
        {columns.map((col) => (
          <div key={col} className="form-field">
            <label className="form-label">
              {getColumnDisplayName(col)}
            </label>
            {isExcludable(col) && (
              <label className="exclude-toggle">
                <input
                  type="checkbox"
                  checked={!excluded.has(col)}
                  onChange={() => toggleExcluded(col)}
                />
                <span className="exclude-toggle-text">
                  {excluded.has(col) ? 'Kolona neće biti ažurirana' : 'Kolona će biti ažurirana'}
                </span>
              </label>
            )}
            <input
              type="text"
              value={String(values[col] ?? '')}
              onChange={(e) => handleChange(col, e.target.value)}
              className={`form-input ${isExcludable(col) && excluded.has(col) ? 'form-input-excluded' : ''}`}
              disabled={isExcludable(col) && excluded.has(col)}
            />
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
