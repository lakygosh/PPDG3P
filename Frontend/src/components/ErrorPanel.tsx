import { useState } from 'react';
import type { ApiError, SqlErrorResponse } from '../types';
import './ErrorPanel.css';

interface ErrorPanelProps {
  error: ApiError | null;
  onClose?: () => void;
}

function isSqlError(error: ApiError): error is SqlErrorResponse {
  return error.type === 'SqlException';
}

export function ErrorPanel({ error, onClose }: ErrorPanelProps) {
  const [expanded, setExpanded] = useState(false);

  if (!error) return null;

  const mainMessage = isSqlError(error)
    ? error.errors[0]?.message || 'Greška baze podataka'
    : error.detail;

  const hasDetails = isSqlError(error) && (
    error.errors.length > 1 ||
    error.errors[0]?.procedure ||
    error.errors[0]?.errorNumber
  );

  return (
    <div className="error-panel-compact">
      <div className="error-icon">!</div>
      <div className="error-content">
        <span className="error-text">{mainMessage}</span>
        {hasDetails && (
          <button
            className="error-expand-btn"
            onClick={() => setExpanded(!expanded)}
            title={expanded ? 'Sakrij detalje' : 'Prikaži detalje'}
          >
            {expanded ? '▲' : '▼'}
          </button>
        )}
      </div>
      {onClose && (
        <button className="error-close-btn" onClick={onClose} title="Zatvori">
          ×
        </button>
      )}
      {expanded && isSqlError(error) && (
        <div className="error-details">
          {error.errors.map((e, i) => (
            <div key={i} className="error-detail-row">
              <span className="detail-label">#{e.errorNumber}</span>
              {e.procedure && <span className="detail-proc">{e.procedure}:{e.lineNumber}</span>}
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
