import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { documentApi, handleApiError } from '../api/client';
import { ErrorPanel } from '../components';
import type { ApiError } from '../types';
import './DocumentsPage.css';

interface DocumentSummary {
  id: number;
  datumPodnosenja: string;
  obveznik: string;
  jmbg: string;
  ukProdajnaCena: number;
  ukNabavnaCena: number;
  kapitalnaOsnovica: number;
}

export function DocumentsPage() {
  const navigate = useNavigate();
  const [documents, setDocuments] = useState<DocumentSummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<ApiError | null>(null);
  const [deleting, setDeleting] = useState<number | null>(null);

  const loadDocuments = async () => {
    setLoading(true);
    setError(null);
    try {
      const result = await documentApi.getAll();
      const mapped = result.map((item) => {
        const doc = item.document as Record<string, unknown> | null;
        const obveznik = doc?.poreskiObveznik as Record<string, unknown> | null;
        return {
          id: item.id,
          datumPodnosenja: formatDate(doc?.datumNacinPodnosenjaPrijave as string),
          obveznik: obveznik ? `${obveznik.ime} ${obveznik.prezime}`.trim() : '-',
          jmbg: String(obveznik?.id || '-'),
          ukProdajnaCena: 0, // These are calculated fields not in view
          ukNabavnaCena: 0,
          kapitalnaOsnovica: 0,
        };
      });
      setDocuments(mapped);
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadDocuments();
  }, []);

  const handleDelete = async (id: number) => {
    if (!confirm('Да ли сте сигурни да желите да обришете ову пријаву?')) return;

    setDeleting(id);
    setError(null);
    try {
      await documentApi.delete(id);
      await loadDocuments();
    } catch (err) {
      setError(handleApiError(err));
    } finally {
      setDeleting(null);
    }
  };

  return (
    <div className="documents-page">
      <div className="page-header">
        <div>
          <h1 className="page-title">ППДГ-3П Пријаве</h1>
          <p className="page-subtitle">Преглед свих пореских пријава за капиталне добитке</p>
        </div>
        <Link to="/documents/new" className="btn btn-primary">
          + Нова пријава
        </Link>
      </div>

      <ErrorPanel error={error} onClose={() => setError(null)} />

      <div className="documents-table-container">
        {loading ? (
          <div className="loading">Учитавање...</div>
        ) : documents.length === 0 ? (
          <div className="empty-state">
            <p>Нема пријава</p>
            <Link to="/documents/new" className="btn btn-primary">
              Креирај прву пријаву
            </Link>
          </div>
        ) : (
          <table className="documents-table">
            <thead>
              <tr>
                <th>ИД</th>
                <th>Датум подношења</th>
                <th>Порески обвезник</th>
                <th>ЈМБГ/ЕСБ/ПИБ</th>
                <th>Акције</th>
              </tr>
            </thead>
            <tbody>
              {documents.map((doc) => (
                <tr key={doc.id}>
                  <td className="id-cell">{doc.id}</td>
                  <td>{doc.datumPodnosenja}</td>
                  <td>{doc.obveznik}</td>
                  <td className="jmbg-cell">{doc.jmbg}</td>
                  <td className="actions-cell">
                    <button
                      className="action-btn view-btn"
                      onClick={() => navigate(`/documents/${doc.id}`)}
                      title="Прикажи/Измени"
                    >
                      ✏️
                    </button>
                    <button
                      className="action-btn delete-btn"
                      onClick={() => handleDelete(doc.id)}
                      disabled={deleting === doc.id}
                      title="Обриши"
                    >
                      {deleting === doc.id ? '...' : '🗑️'}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}

function formatDate(dateStr: string | undefined): string {
  if (!dateStr) return '-';
  try {
    const date = new Date(dateStr);
    return date.toLocaleDateString('sr-RS');
  } catch {
    return dateStr;
  }
}
