import { useState, useEffect, useCallback } from 'react';
import { useParams } from 'react-router-dom';
import { metadataApi, tableApi, handleApiError } from '../api/client';
import { DataGrid, RecordForm, ErrorPanel } from '../components';
import { getTableDisplayName } from '../types';
import type { TableMetadata, ApiError } from '../types';
import './TablePage.css';

type ModalMode = 'none' | 'insert' | 'edit' | 'delete';

export function TablePage() {
  const { tableName } = useParams<{ tableName: string }>();
  const [metadata, setMetadata] = useState<TableMetadata | null>(null);
  const [data, setData] = useState<Record<string, unknown>[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<ApiError | null>(null);
  const [modalMode, setModalMode] = useState<ModalMode>('none');
  const [selectedRow, setSelectedRow] = useState<Record<string, unknown> | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const loadData = useCallback(async () => {
    if (!tableName) return;

    setLoading(true);
    setError(null);

    try {
      const [metadataResult, dataResult] = await Promise.all([
        metadataApi.getTableMetadata(tableName),
        tableApi.getAll(tableName),
      ]);

      setMetadata(metadataResult);
      setData(dataResult.rows);
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
    if (!tableName || !metadata || !selectedRow) return;

    setSubmitting(true);
    setError(null);

    // Build keys from primary key columns
    const keys: Record<string, unknown> = {};
    metadata.primaryKeyColumns.forEach((pk) => {
      keys[pk] = selectedRow[pk];
    });

    try {
      await tableApi.update(tableName, keys, values);
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
    if (!tableName || !metadata || !selectedRow) return;

    setSubmitting(true);
    setError(null);

    // Build keys from primary key columns
    const keys: Record<string, unknown> = {};
    metadata.primaryKeyColumns.forEach((pk) => {
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

  const isView = metadata?.tableType === 'VIEW';

  return (
    <div className="table-page">
      <div className="page-header">
        <div>
          <h1 className="page-title">
            {tableName ? getTableDisplayName(tableName) : 'Učitavanje...'}
          </h1>
          <p className="page-subtitle">
            {isView ? 'Pogled (samo za čitanje)' : `Tabela • ${data.length} redova`}
          </p>
        </div>
        {!isView && metadata && (
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

      {metadata && (
        <DataGrid
          columns={metadata.columns}
          data={data}
          primaryKeyColumns={metadata.primaryKeyColumns}
          onEdit={!isView ? openEditModal : undefined}
          onDelete={!isView ? openDeleteModal : undefined}
          loading={loading}
        />
      )}

      {/* Insert Modal */}
      {modalMode === 'insert' && metadata && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">Dodaj novi zapis</h2>
              <button className="modal-close" onClick={closeModal}>×</button>
            </div>
            <div className="modal-body">
              <ErrorPanel error={error} onClose={() => setError(null)} />
              <RecordForm
                columns={metadata.columns}
                foreignKeys={metadata.foreignKeys}
                onSubmit={handleInsert}
                onCancel={closeModal}
                loading={submitting}
              />
            </div>
          </div>
        </div>
      )}

      {/* Edit Modal */}
      {modalMode === 'edit' && metadata && selectedRow && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">Izmeni zapis</h2>
              <button className="modal-close" onClick={closeModal}>×</button>
            </div>
            <div className="modal-body">
              <ErrorPanel error={error} onClose={() => setError(null)} />
              <RecordForm
                columns={metadata.columns}
                foreignKeys={metadata.foreignKeys}
                initialValues={selectedRow}
                onSubmit={handleUpdate}
                onCancel={closeModal}
                isEdit
                loading={submitting}
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
                {metadata?.primaryKeyColumns.map((pk) => (
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
