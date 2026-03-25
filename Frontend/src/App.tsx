import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Layout } from './components';
import { Dashboard, TablePage, DocumentsPage, DocumentFormPage } from './pages';
import './App.css';

function App() {
  return (
    <BrowserRouter>
      <Layout>
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/documents" element={<DocumentsPage />} />
          <Route path="/documents/new" element={<DocumentFormPage />} />
          <Route path="/documents/:id" element={<DocumentFormPage />} />
          <Route path="/table/:tableName" element={<TablePage />} />
          <Route path="/view/:tableName" element={<TablePage />} />
        </Routes>
      </Layout>
    </BrowserRouter>
  );
}

export default App;
