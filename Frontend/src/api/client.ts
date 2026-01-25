import axios, { AxiosError } from 'axios';
import type {
  TableMetadata,
  QueryResult,
  InsertResult,
  AffectedRowsResult,
  KdtHierarchy,
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

// Metadata API
export const metadataApi = {
  getTables: async (): Promise<TableMetadata[]> => {
    const response = await api.get<TableMetadata[]>('/metadata/tables');
    return response.data;
  },

  getViews: async (): Promise<TableMetadata[]> => {
    const response = await api.get<TableMetadata[]>('/metadata/views');
    return response.data;
  },

  getTableMetadata: async (tableName: string): Promise<TableMetadata> => {
    const response = await api.get<TableMetadata>(`/metadata/tables/${encodeURIComponent(tableName)}`);
    return response.data;
  },

  getProcedures: async (): Promise<string[]> => {
    const response = await api.get<string[]>('/metadata/procedures');
    return response.data;
  },
};

// Table CRUD API
export const tableApi = {
  getAll: async (
    tableName: string,
    options?: { top?: number; offset?: number; orderBy?: string; orderDir?: 'ASC' | 'DESC' }
  ): Promise<QueryResult> => {
    const params = new URLSearchParams();
    if (options?.top) params.append('top', String(options.top));
    if (options?.offset) params.append('offset', String(options.offset));
    if (options?.orderBy) params.append('orderBy', options.orderBy);
    if (options?.orderDir) params.append('orderDir', options.orderDir);

    const response = await api.get<QueryResult>(`/table/${encodeURIComponent(tableName)}?${params}`);
    return response.data;
  },

  findByKey: async (tableName: string, keys: Record<string, unknown>): Promise<QueryResult> => {
    const params = new URLSearchParams();
    Object.entries(keys).forEach(([key, value]) => {
      params.append(key, String(value));
    });

    const response = await api.get<QueryResult>(`/table/${encodeURIComponent(tableName)}/find?${params}`);
    return response.data;
  },

  insert: async (tableName: string, values: Record<string, unknown>): Promise<InsertResult> => {
    const response = await api.post<InsertResult>(`/table/${encodeURIComponent(tableName)}`, { values });
    return response.data;
  },

  update: async (
    tableName: string,
    keys: Record<string, unknown>,
    values: Record<string, unknown>
  ): Promise<AffectedRowsResult> => {
    const response = await api.put<AffectedRowsResult>(`/table/${encodeURIComponent(tableName)}`, { keys, values });
    return response.data;
  },

  delete: async (tableName: string, keys: Record<string, unknown>): Promise<AffectedRowsResult> => {
    const response = await api.delete<AffectedRowsResult>(`/table/${encodeURIComponent(tableName)}`, {
      data: { keys },
    });
    return response.data;
  },

  executeProcedure: async (procedureName: string, parameters?: Record<string, unknown>): Promise<QueryResult> => {
    const response = await api.post<QueryResult>(`/table/procedure/${encodeURIComponent(procedureName)}`, parameters);
    return response.data;
  },
};

// KDT API
export const kdtApi = {
  getHierarchies: async (): Promise<KdtHierarchy[]> => {
    const response = await api.get<KdtHierarchy[]>('/kdt/hierarchies');
    return response.data;
  },

  getHierarchy: async (name: string): Promise<KdtHierarchy> => {
    const response = await api.get<KdtHierarchy>(`/kdt/hierarchies/${encodeURIComponent(name)}`);
    return response.data;
  },

  getAll: async (hierarchyName: string): Promise<QueryResult> => {
    const response = await api.get<QueryResult>(`/kdt/${encodeURIComponent(hierarchyName)}`);
    return response.data;
  },

  getByKey: async (hierarchyName: string, keyValue: string): Promise<unknown> => {
    const response = await api.get(`/kdt/${encodeURIComponent(hierarchyName)}/${encodeURIComponent(keyValue)}`);
    return response.data;
  },

  insert: async (
    hierarchyName: string,
    childType: string,
    parentValues: Record<string, unknown>,
    childValues: Record<string, unknown>
  ): Promise<{ message: string; insertedKey: unknown }> => {
    const response = await api.post(`/kdt/${encodeURIComponent(hierarchyName)}/${encodeURIComponent(childType)}`, {
      parentValues,
      childValues,
    });
    return response.data;
  },

  update: async (
    hierarchyName: string,
    childType: string,
    keys: Record<string, unknown>,
    parentValues: Record<string, unknown>,
    childValues: Record<string, unknown>
  ): Promise<AffectedRowsResult> => {
    const response = await api.put(`/kdt/${encodeURIComponent(hierarchyName)}/${encodeURIComponent(childType)}`, {
      keys,
      parentValues,
      childValues,
    });
    return response.data;
  },

  delete: async (hierarchyName: string, keys: Record<string, unknown>): Promise<AffectedRowsResult> => {
    const response = await api.delete(`/kdt/${encodeURIComponent(hierarchyName)}`, {
      data: { keys },
    });
    return response.data;
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

  create: async (data: {
    datumOstvarivanjaPrihoda: string;
    datumDospelostiZaPodnosenjePrijave: string;
    datumNacinPodnosenjaPrijave: string;
    izmena: boolean;
    idOrganaPoreske: number;
    idPoreskogObveznika: number;
    idVrstePrijave: number;
    idOsnovaZaPrijavu: number;
    email?: string;
  }): Promise<{ id: number }> => {
    const response = await api.post('/document', data);
    return response.data;
  },

  update: async (id: number, jsonDoc: unknown): Promise<{ message: string }> => {
    const response = await api.put(`/document/${id}`, jsonDoc);
    return response.data;
  },

  partialUpdate: async (id: number, jsonDoc: unknown): Promise<{ message: string }> => {
    const response = await api.patch(`/document/${id}`, jsonDoc);
    return response.data;
  },

  recalculate: async (id: number): Promise<{ message: string }> => {
    const response = await api.post(`/document/${id}/recalculate`);
    return response.data;
  },

  delete: async (id: number): Promise<AffectedRowsResult> => {
    const response = await api.delete(`/document/${id}`);
    return response.data;
  },
};

export default api;
