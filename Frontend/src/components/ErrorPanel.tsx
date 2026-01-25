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
  if (!error) return null;

  return (
    <div className="error-panel">
      <div className="error-panel-header">
        <h3>Greška baze podataka</h3>
        {onClose && (
          <button className="error-close-btn" onClick={onClose}>
            ×
          </button>
        )}
      </div>
      <div className="error-panel-content">
        {isSqlError(error) ? (
          <div className="sql-errors">
            {error.errors.map((e, i) => (
              <div key={i} className="sql-error-item">
                <div className="error-number">
                  <strong>Greška #{e.errorNumber}</strong>
                  <span className="error-class">Klasa: {e.class}, Stanje: {e.state}</span>
                </div>
                <div className="error-message">{e.message}</div>
                {e.procedure && (
                  <div className="error-detail">
                    <span>Procedura:</span> {e.procedure}
                  </div>
                )}
                <div className="error-detail">
                  <span>Linija:</span> {e.lineNumber}
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div className="general-error">
            <p>{error.detail}</p>
          </div>
        )}
      </div>
    </div>
  );
}
