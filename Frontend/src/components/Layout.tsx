import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { getTableDisplayName } from '../types';
import './Layout.css';

interface LayoutProps {
  children: React.ReactNode;
}

const allTables = [
  { name: 'PPDG3P', group: 'Prijave' },
  { name: 'PPDG3P_Details', group: 'Prijave' },
  { name: 'PoreskiObveznik', group: 'Lica' },
  { name: 'Lice', group: 'Lica' },
  { name: 'Fizicko', group: 'Lica' },
  { name: 'Pravno', group: 'Lica' },
  { name: 'Broker', group: 'Lica' },
  { name: 'Punomocnik', group: 'Lica' },
  { name: 'OrgPU', group: 'Šifarnici' },
  { name: 'Dokazi', group: 'Dokumenta' },
  { name: 'DokumentOSticanju', group: 'Dokumenta' },
  { name: 'StavkaPrenosa', group: 'Stavke' },
  { name: 'PrenosHartijaOdVrednosti', group: 'Stavke' },
  { name: 'StavkaUmanjenja', group: 'Stavke' },
  { name: 'KapitalniGubitak', group: 'Stavke' },
  { name: 'UlaganjeUOsnKap', group: 'Stavke' },
  { name: 'UlaganjneUResavanjeSP', group: 'Stavke' },
];

const groups = ['Prijave', 'Lica', 'Šifarnici', 'Dokumenta', 'Stavke'];

export function Layout({ children }: LayoutProps) {
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const location = useLocation();

  const isActive = (path: string) => location.pathname === path;

  return (
    <div className="layout">
      <aside className={`sidebar ${sidebarOpen ? 'open' : 'closed'}`}>
        <div className="sidebar-header">
          <h1 className="app-title">PPDG-3P</h1>
          <span className="app-subtitle">Sistem za prijavu poreza</span>
          <button
            className="sidebar-toggle"
            onClick={() => setSidebarOpen(!sidebarOpen)}
          >
            {sidebarOpen ? '◀' : '▶'}
          </button>
        </div>

        <nav className="sidebar-nav">
          <div className="nav-section">
            <h2 className="nav-section-title">Главни мени</h2>
            <Link
              to="/"
              className={`nav-link ${isActive('/') ? 'active' : ''}`}
            >
              Kontrolna tabla
            </Link>
            <Link
              to="/documents"
              className={`nav-link highlight ${location.pathname.startsWith('/documents') ? 'active' : ''}`}
            >
              PPDG-3P Prijave (forma)
            </Link>
          </div>

          {groups.map((group) => (
            <div className="nav-section" key={group}>
              <h2 className="nav-section-title">{group}</h2>
              {allTables
                .filter((t) => t.group === group)
                .map((t) => (
                  <Link
                    key={t.name}
                    to={`/table/${t.name}`}
                    className={`nav-link ${isActive(`/table/${t.name}`) ? 'active' : ''}`}
                  >
                    {getTableDisplayName(t.name)}
                  </Link>
                ))}
            </div>
          ))}
        </nav>
      </aside>

      <main className="main-content">
        {children}
      </main>
    </div>
  );
}
