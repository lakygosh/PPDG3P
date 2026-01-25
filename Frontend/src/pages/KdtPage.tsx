import { useState, useEffect, useCallback } from 'react';
import { useParams } from 'react-router-dom';
import { kdtApi, metadataApi, handleApiError } from '../api/client';
import { DataGrid, ErrorPanel } from '../components';
import { getTableDisplayName, getColumnDisplayName } from '../types';
import type { KdtHierarchy, TableMetadata, ApiError } from '../types';
import './KdtPage.css';

type ModalMode = 'none' | 'insert' | 'edit' | 'view';

// Serbian translations for KDT types
const kdtTypeTranslations: Record<string, string> = {
  'FIZICKO': 'Fizičko lice',
  'PRAVNO': 'Pravno lice',
  'BROKER': 'Broker',
  'KAP_GUB': 'Kapitalni gubitak',
  'OSN_KAP': 'Ulaganje u osnovni kapital',
  'RES_SP': 'Rešavanje stambenog pitanja',
  'HARTIJE': 'Hartije od vrednosti',
  'DETAILS': 'Detalji',
};

export function KdtPage() {
  const { hierarchyName } = useParams<{ hierarchyName: string }>();
  const [hierarchy, setHierarchy] = useState<KdtHierarchy | null>(null);
  const [parentMetadata, setParentMetadata] = useState<TableMetadata | null>(null);
  const [childMetadata, setChildMetadata] = useState<Record<string, TableMetadata>>({});
  const [data, setData] = useState<Record<string, unknown>[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<ApiError | null>(null);
  const [modalMode, setModalMode] = useState<ModalMode>('none');
  const [selectedRow, setSelectedRow] = useState<Record<string, unknown> | null>(null);
  const [selectedType, setSelectedType] = useState<string>('');
  const [formValues, setFormValues] = useState<Record<string, unknown>>({});
  const [submitting, setSubmitting] = useState(false);

  const loadData = useCallback(async () => {
    if (!hierarchyName) return;

    setLoading(true);
    setError(null);

    try {
      const [hierarchyResult, dataResult] = await Promise.all([
        kdtApi.getHierarchy(hierarchyName),
        kdtApi.getAll(hierarchyName),
      ]);

      setHierarchy(hierarchyResult);
      setData(dataResult.rows);

      // Load parent metadata
      const parentMeta = await metadataApi.getTableMetadata(hierarchyResult.parentTable);
      setParentMetadata(parentMeta);

      // Load child metadata
      const childMeta: Record<string, TableMetadata> = {};
      for (const child of hierarchyResult.childTables) {
        try {
          childMeta[child.tableName] = await metadataApi.getTableMetadata(child.tableName);
        } catch (err) {
          console.error(`Failed to load metadata for ${child.tableName}`);
        }
      }
      setChildMetadata(childMeta);
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  }, [hierarchyName]);

  useEffect(() => {
    loadData();
  }, [loadData]);

  const handleOpenInsert = () => {
    setModalMode('insert');
    setSelectedRow(null);
    setSelectedType('');
    setFormValues({});
    setError(null);
  };

  const handleOpenEdit = (row: Record<string, unknown>) => {
    setSelectedRow(row);
    // Determine type from row
    const typeCol = Object.keys(row).find(k => k.startsWith('_Type_'));
    if (typeCol) {
      const typeName = row[typeCol] as string;
      setSelectedType(typeName || '');
    }
    setFormValues(row);
    setModalMode('edit');
    setError(null);
  };

  const handleDelete = async (row: Record<string, unknown>) => {
    if (!hierarchy) return;

    if (!confirm('Da li ste sigurni da želite da obrišete ovaj zapis?')) {
      return;
    }

    setError(null);

    const keys: Record<string, unknown> = {
      [hierarchy.parentKeyColumn]: row[hierarchy.parentKeyColumn],
    };

    try {
      await kdtApi.delete(hierarchy.name, keys);
      await loadData();
    } catch (err) {
      setError(handleApiError(err));
    }
  };

  const handleSubmit = async () => {
    if (!hierarchy || !selectedType) return;

    setSubmitting(true);
    setError(null);

    try {
      // Separate parent and child values
      const parentValues: Record<string, unknown> = {};
      const childValues: Record<string, unknown> = {};

      const childTable = hierarchy.childTables.find(c => c.typeDiscriminator === selectedType);
      const childMeta = childTable ? childMetadata[childTable.tableName] : null;
      const childColumns = childMeta?.columns.map(c => c.columnName) || [];

      Object.entries(formValues).forEach(([key, value]) => {
        // Skip type indicator columns
        if (key.startsWith('_Type_')) return;
        // Skip empty values
        if (value === '' || value === null || value === undefined) return;

        if (childColumns.includes(key)) {
          childValues[key] = value;
        } else {
          parentValues[key] = value;
        }
      });

      if (modalMode === 'insert') {
        await kdtApi.insert(hierarchy.name, selectedType, parentValues, childValues);
      } else if (modalMode === 'edit' && selectedRow) {
        const keys: Record<string, unknown> = {
          [hierarchy.parentKeyColumn]: selectedRow[hierarchy.parentKeyColumn],
        };
        await kdtApi.update(hierarchy.name, selectedType, keys, parentValues, childValues);
      }

      setModalMode('none');
      await loadData();
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setSubmitting(false);
    }
  };

  const closeModal = () => {
    setModalMode('none');
    setSelectedRow(null);
    setSelectedType('');
    setFormValues({});
  };

  const handleFieldChange = (field: string, value: unknown) => {
    setFormValues(prev => ({ ...prev, [field]: value }));
  };

  const getColumnsForDisplay = () => {
    if (!parentMetadata) return [];
    return parentMetadata.columns;
  };

  return (
    <div className="kdt-page">
      <div className="page-header">
        <div>
          <h1 className="page-title">
            {hierarchyName ? getTableDisplayName(hierarchyName) : 'Učitavanje...'}
          </h1>
          <p className="page-subtitle">
            KDT Hijerarhija • {data.length} zapisa
          </p>
        </div>
        {hierarchy && (
          <button className="btn btn-primary" onClick={handleOpenInsert}>
            + Dodaj novi zapis
          </button>
        )}
      </div>

      <ErrorPanel error={error} onClose={() => setError(null)} />

      {hierarchy && (
        <div className="kdt-info">
          <h3>Tipovi u hijerarhiji:</h3>
          <div className="type-badges">
            {hierarchy.childTables.map((child) => (
              <span key={child.tableName} className="type-badge">
                {kdtTypeTranslations[child.typeDiscriminator] || child.typeDiscriminator}
              </span>
            ))}
          </div>
        </div>
      )}

      {parentMetadata && (
        <DataGrid
          columns={getColumnsForDisplay()}
          data={data}
          primaryKeyColumns={parentMetadata.primaryKeyColumns}
          onEdit={handleOpenEdit}
          onDelete={handleDelete}
          loading={loading}
        />
      )}

      {/* Insert/Edit Modal */}
      {(modalMode === 'insert' || modalMode === 'edit') && hierarchy && (
        <div className="modal-overlay" onClick={closeModal}>
          <div className="modal modal-large" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h2 className="modal-title">
                {modalMode === 'insert' ? 'Dodaj novi zapis' : 'Izmeni zapis'}
              </h2>
              <button className="modal-close" onClick={closeModal}>×</button>
            </div>
            <div className="modal-body">
              <ErrorPanel error={error} onClose={() => setError(null)} />

              {/* Type selector */}
              <div className="type-selector">
                <label>Tip zapisa:</label>
                <div className="type-options">
                  {hierarchy.childTables.map((child) => (
                    <button
                      key={child.tableName}
                      className={`type-option ${selectedType === child.typeDiscriminator ? 'active' : ''}`}
                      onClick={() => setSelectedType(child.typeDiscriminator)}
                      type="button"
                    >
                      {kdtTypeTranslations[child.typeDiscriminator] || child.typeDiscriminator}
                    </button>
                  ))}
                </div>
              </div>

              {selectedType && (
                <div className="kdt-form">
                  {/* Parent fields */}
                  {parentMetadata && (
                    <div className="form-section">
                      <h4>Osnovni podaci ({getTableDisplayName(hierarchy.parentTable)})</h4>
                      <div className="form-grid">
                        {parentMetadata.columns
                          .filter(col => !col.columnName.startsWith('_'))
                          .map((col) => (
                            <div key={col.columnName} className="form-field">
                              <label className="form-label">
                                {getColumnDisplayName(col.columnName)}
                                {!col.isNullable && !col.isIdentity && <span className="required">*</span>}
                                {col.isIdentity && <span className="identity-badge">Auto</span>}
                              </label>
                              <input
                                type={getInputType(col.dataType)}
                                value={String(formValues[col.columnName] ?? '')}
                                onChange={(e) => handleFieldChange(col.columnName, e.target.value)}
                                disabled={col.isIdentity}
                                className="form-input"
                              />
                            </div>
                          ))}
                      </div>
                    </div>
                  )}

                  {/* Child fields */}
                  {selectedType && (() => {
                    const childTable = hierarchy.childTables.find(c => c.typeDiscriminator === selectedType);
                    const meta = childTable ? childMetadata[childTable.tableName] : null;
                    if (!meta) return null;

                    return (
                      <div className="form-section">
                        <h4>Specifični podaci ({getTableDisplayName(childTable!.tableName)})</h4>
                        <div className="form-grid">
                          {meta.columns
                            .filter(col => col.columnName !== childTable!.foreignKeyColumn)
                            .map((col) => (
                              <div key={col.columnName} className="form-field">
                                <label className="form-label">
                                  {getColumnDisplayName(col.columnName)}
                                  {!col.isNullable && <span className="required">*</span>}
                                </label>
                                <input
                                  type={getInputType(col.dataType)}
                                  value={String(formValues[col.columnName] ?? '')}
                                  onChange={(e) => handleFieldChange(col.columnName, e.target.value)}
                                  className="form-input"
                                />
                              </div>
                            ))}
                        </div>
                      </div>
                    );
                  })()}

                  <div className="form-actions">
                    <button className="btn btn-secondary" onClick={closeModal} disabled={submitting}>
                      Otkaži
                    </button>
                    <button className="btn btn-primary" onClick={handleSubmit} disabled={submitting}>
                      {submitting ? 'Čuvanje...' : modalMode === 'insert' ? 'Dodaj' : 'Sačuvaj'}
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

function getInputType(dataType: string): string {
  if (dataType.includes('date')) return 'date';
  if (['int', 'bigint', 'decimal', 'money', 'real', 'float'].includes(dataType)) return 'number';
  return 'text';
}
