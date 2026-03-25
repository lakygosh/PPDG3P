import axios, { AxiosError } from 'axios';
import type {
  ApiError
} from '../types';

const API_BASE_URL = 'http://localhost:5000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Error handler that extracts API error details
export function handleApiError(error: unknown): ApiError {
  if (axios.isAxiosError(error)) {
    const axiosError = error as AxiosError<ApiError>;
    if (axiosError.response?.data) {
      return axiosError.response.data;
    }
    return {
      type: 'ArgumentException',
      title: 'Greška',
      status: axiosError.response?.status || 500,
      detail: axiosError.message || 'Nepoznata greška',
    };
  }
  return {
    type: 'ArgumentException',
    title: 'Greška',
    status: 500,
    detail: String(error),
  };
}

// Simple table response
export interface SimpleTableResponse {
  rows: Record<string, unknown>[];
  columns: string[];
  primaryKey: string[];
  excludableColumns?: string[];
}

// Simple CRUD API - one endpoint per table
export const tableApi = {
  getAll: async (tableName: string): Promise<SimpleTableResponse> => {
    const response = await api.get<SimpleTableResponse>(`/tables/${tableName}`);
    return response.data;
  },

  insert: async (tableName: string, values: Record<string, unknown>): Promise<void> => {
    await api.post(`/tables/${tableName}`, values);
  },

  update: async (tableName: string, values: Record<string, unknown>): Promise<void> => {
    await api.put(`/tables/${tableName}`, values);
  },

  delete: async (tableName: string, keys: Record<string, unknown>): Promise<void> => {
    await api.delete(`/tables/${tableName}`, { data: keys });
  },
};

// Document API (PPDG3P specific)
export const documentApi = {
  getAll: async (): Promise<{ id: number; document: unknown }[]> => {
    const response = await api.get('/document');
    return response.data;
  },

  getById: async (id: number): Promise<{ id: number; document: unknown }> => {
    const response = await api.get(`/document/${id}`);
    return response.data;
  },

  create: async (jsonDoc: unknown): Promise<{ id: number }> => {
    const response = await api.post('/document', jsonDoc);
    return response.data;
  },

  update: async (id: number, jsonDoc: unknown): Promise<{ message: string }> => {
    const response = await api.put(`/document/${id}`, jsonDoc);
    return response.data;
  },

  delete: async (id: number): Promise<{ affectedRows: number }> => {
    const response = await api.delete(`/document/${id}`);
    return response.data;
  },
};

export default api;
