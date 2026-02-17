import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { tableApi } from '../api/client';
import './Dashboard.css';

interface TableStats {
  tableName: string;
  rowCount: number;
}

export function Dashboard() {
  const [stats, setStats] = useState<TableStats[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const loadData = async () => {
      try {
        // Load row counts for main tables
        const mainTables = ['PPDG3P', 'PoreskiObveznik', 'StavkaPrenosa', 'StavkaUmanjenja', 'Dokazi'];
        const statsPromises = mainTables.map(async (name) => {
          try {
            const result = await tableApi.getAll(name);
            return { tableName: name, rowCount: result.totalCount };
          } catch {
            return { tableName: name, rowCount: 0 };
          }
        });

        const statsData = await Promise.all(statsPromises);
        setStats(statsData);
      } catch (err) {
        console.error('Failed to load dashboard data:', err);
      } finally {
        setLoading(false);
      }
    };

    loadData();
  }, []);

  const getStatForTable = (tableName: string): number => {
    return stats.find((s) => s.tableName === tableName)?.rowCount ?? 0;
  };

  if (loading) {
    return (
      <div className="loading-container">
        <div className="spinner"></div>
        <p>Učitavanje...</p>
      </div>
    );
  }

  return (
    <div className="dashboard">
      <div className="page-header">
        <div>
          <h1 className="page-title">Kontrolna tabla</h1>
          <p className="page-subtitle">Pregled sistema za prijavu poreza na kapitalni dobitak</p>
        </div>
      </div>

      <div className="stats-grid">
        <div className="stat-card primary">
          <div className="stat-icon">📝</div>
          <div className="stat-content">
            <div className="stat-value">{getStatForTable('PPDG3P')}</div>
            <div className="stat-label">Ukupno prijava</div>
          </div>
          <Link to="/table/PPDG3P" className="stat-link">Pogledaj sve →</Link>
        </div>

        <div className="stat-card success">
          <div className="stat-icon">👥</div>
          <div className="stat-content">
            <div className="stat-value">{getStatForTable('PoreskiObveznik')}</div>
            <div className="stat-label">Poreskih obveznika</div>
          </div>
          <Link to="/table/PoreskiObveznik" className="stat-link">Pogledaj sve →</Link>
        </div>

        <div className="stat-card warning">
          <div className="stat-icon">💰</div>
          <div className="stat-content">
            <div className="stat-value">{getStatForTable('StavkaPrenosa')}</div>
            <div className="stat-label">Stavki prenosa</div>
          </div>
          <Link to="/table/StavkaPrenosa" className="stat-link">Pogledaj sve →</Link>
        </div>

        <div className="stat-card info">
          <div className="stat-icon">📉</div>
          <div className="stat-content">
            <div className="stat-value">{getStatForTable('StavkaUmanjenja')}</div>
            <div className="stat-label">Stavki umanjenja</div>
          </div>
          <Link to="/table/StavkaUmanjenja" className="stat-link">Pogledaj sve →</Link>
        </div>
      </div>

      <div className="quick-actions">
        <h2>Brze akcije</h2>
        <div className="action-buttons">
          <Link to="/table/PPDG3P" className="action-button">
            <span className="action-icon">➕</span>
            <span>Nova prijava</span>
          </Link>
          <Link to="/table/PoreskiObveznik" className="action-button">
            <span className="action-icon">👤</span>
            <span>Novi obveznik</span>
          </Link>
          <Link to="/kdt/Lice" className="action-button">
            <span className="action-icon">🏢</span>
            <span>Nova osoba/firma</span>
          </Link>
          <Link to="/view/vw_PPDG3P_Document" className="action-button">
            <span className="action-icon">📄</span>
            <span>Pregled dokumenata</span>
          </Link>
        </div>
      </div>

    </div>
  );
}
