import { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import './Layout.css';

interface LayoutProps {
  children: React.ReactNode;
}

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
              🏠 Контролна табла
            </Link>
            <Link
              to="/documents"
              className={`nav-link highlight ${location.pathname.startsWith('/documents') ? 'active' : ''}`}
            >
              📝 ППДГ-3П Пријаве
            </Link>
            <Link
              to="/documents/new"
              className={`nav-link ${isActive('/documents/new') ? 'active' : ''}`}
            >
              ➕ Нова пријава
            </Link>
          </div>

          <div className="nav-section">
            <h2 className="nav-section-title">KDT Hijerarhije</h2>
            <Link
              to="/kdt/Lice"
              className={`nav-link ${location.pathname.startsWith('/kdt/Lice') ? 'active' : ''}`}
            >
              👤 Lica (KDT)
            </Link>
            <Link
              to="/kdt/StavkaUmanjenja"
              className={`nav-link ${location.pathname.startsWith('/kdt/StavkaUmanjenja') ? 'active' : ''}`}
            >
              📉 Stavke umanjenja (KDT)
            </Link>
          </div>
        </nav>
      </aside>

      <main className="main-content">
        {children}
      </main>
    </div>
  );
}
