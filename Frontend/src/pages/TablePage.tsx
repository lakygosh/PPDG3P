import { useState, useEffect, useCallback } from 'react';
import { useParams } from 'react-router-dom';
import { tableApi, handleApiError } from '../api/client';
import { DataGrid, RecordForm, ErrorPanel } from '../components';
import { getTableDisplayName } from '../types';
import type { ApiError } from '../types';
import './TablePage.css';

type ModalMode = 'none' | 'insert' | 'edit' | 'delete';

export function TablePage() {
  const { tableName } = useParams<{ tableName: string }>();
  const [columns, setColumns] = useState<string[]>([]);
  const [primaryKey, setPrimaryKey] = useState<string[]>([]);
  const [data, setData] = useState<Record<string, unknown>[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<ApiError | null>(null);
  const [modalMode, setModalMode] = useState<ModalMode>('none');
  const [selectedRow, setSelectedRow] = useState<Record<string, unknown> | null>(null);
  const [excludableColumns, setExcludableColumns] = useState<string[]>([]);
  const [submitting, setSubmitting] = useState(false);

  const loadData = useCallback(async () => {
    if (!tableName) return;

    setLoading(true);
    setError(null);

    try {
      const result = await tableApi.getAll(tableName);
      setData(result.rows);
      setColumns(result.columns);
      setPrimaryKey(result.primaryKey);
      setExcludableColumns(result.excludableColumns ?? []);
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  }, [tableName]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleInsert = async (values: Record<string, unknown>) => {
    if (!tableName) return;

    setSubmitting(true);
    setError(null);

    try {
      await tableApi.insert(tableName, values);
      setModalMode('none');
      await loadData();
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setSubmitting(false);
    }
  };

  const handleUpdate = async (values: Record<string, unknown>) => {
    if (!tableName || !selectedRow) return;

    setSubmitting(true);
    setError(null);

    const payload: Record<string, unknown> = { ...values };
    columns.forEach((col) => {
      payload[`_original_${col}`] = selectedRow[col] ?? null;
    });

    try {
      await tableApi.update(tableName, payload);
      setModalMode('none');
      setSelectedRow(null);
      await loadData();
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setSubmitting(false);
    }
  };

  const handleDelete = async () => {
    if (!tableName || !selectedRow) return;

    setSubmitting(true);
    setError(null);

    const keys: Record<string, unknown> = {};
    primaryKey.forEach((pk) => {
      keys[pk] = selectedRow[pk];
    });

    try {
      await tableApi.delete(tableName, keys);
      setModalMode('none');
      setSelectedRow(null);
      await loadData();
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setSubmitting(false);
    }
  };

  const openEditModal = (row: Record<string, unknown>) => {
    setSelectedRow(row);
    setModalMode('edit');
    setError(null);
  };

  const openDeleteModal = (row: Record<string, unknown>) => {
    setSelectedRow(row);
    setModalMode('delete');
    setError(null);
  };

  const closeModal = () => {
    setModalMode('none');
    setSelectedRow(null);
  };

  return (
    <div className="table-page">
      <div className="page-header">
        <div>
          <h1 className="page-title">
            {tableName ? getTableDisplayName(tableName) : 'Učitavanje...'}
          </h1>
          <p className="page-subtitle">
            {`Tabela • ${data.length} redova`}
          </p>
        </div>
        {columns.length > 0 && (
          <button
            className="btn btn-primary"
            onClick={() => {
              setModalMode('insert');
              setSelectedRow(null);
              setError(null);
            }}
          >
            + Dodaj novi zapis
          </button>
        )}
      </div>

      <ErrorPanel error={error} onClose={() => setError(null)} />

      {columns.length > 0 && (
        <DataGrid
          columns={columns}
          data={data}
          primaryKeyColumns={primaryKey}
          onEdit={openEditModal}
          onDelete={openDeleteModal}
          loading={loading}
        />
      )}

      {/* Insert Modal */}
      {modalMode === 'insert' && columns.length > 0 && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">Dodaj novi zapis</h2>
              <button className="modal-close" onClick={closeModal}>×</button>
            </div>
            <div className="modal-body">
              <ErrorPanel error={error} onClose={() => setError(null)} />
              <RecordForm
                columns={columns}
                onSubmit={handleInsert}
                onCancel={closeModal}
                loading={submitting}
              />
            </div>
          </div>
        </div>
      )}

      {/* Edit Modal */}
      {modalMode === 'edit' && columns.length > 0 && selectedRow && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">Izmeni zapis</h2>
              <button className="modal-close" onClick={closeModal}>×</button>
            </div>
            <div className="modal-body">
              <ErrorPanel error={error} onClose={() => setError(null)} />
              <RecordForm
                columns={columns}
                initialValues={selectedRow}
                onSubmit={handleUpdate}
                onCancel={closeModal}
                isEdit
                loading={submitting}
                excludableColumns={excludableColumns}
              />
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {modalMode === 'delete' && selectedRow && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal modal-small" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">Potvrda brisanja</h2>
              <button className="modal-close" onClick={closeModal}>×</button>
            </div>
            <div className="modal-body">
              <ErrorPanel error={error} onClose={() => setError(null)} />
              <p className="delete-warning">
                Da li ste sigurni da želite da obrišete ovaj zapis?
              </p>
              <div className="delete-details">
                {primaryKey.map((pk) => (
                  <div key={pk}>
                    <strong>{pk}:</strong> {String(selectedRow[pk])}
                  </div>
                ))}
              </div>
              <div className="form-actions">
                <button className="btn btn-secondary" onClick={closeModal} disabled={submitting}>
                  Otkaži
                </button>
                <button className="btn btn-danger" onClick={handleDelete} disabled={submitting}>
                  {submitting ? 'Brisanje...' : 'Obriši'}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
