# PPDG3P API Documentation

## Overview

This is a generic database UI API for the PPDG3P (Serbian capital gains tax form) database. The API provides CRUD operations for all tables and views using raw SQL commands via ADO.NET.

**Base URL:** `http://localhost:5000/api`

**Important Design Principles:**
- No ORM - all database access via raw SQL/ADO.NET
- No UI-side validation - all validation is done by database constraints
- All database errors are returned verbatim to the client
- Tables/columns are whitelisted via INFORMATION_SCHEMA queries

---

## Error Handling

All database errors are returned in the following format:

```json
{
  "type": "SqlException",
  "title": "Database Error",
  "status": 400,
  "errors": [
    {
      "errorNumber": 547,
      "message": "The INSERT statement conflicted with the FOREIGN KEY constraint...",
      "procedure": null,
      "lineNumber": 1,
      "state": 0,
      "class": 16,
      "server": "localhost\\SQLEXPRESS"
    }
  ]
}
```

**Frontend should display these errors exactly as received.**

---

## API Endpoints

### 1. Metadata Endpoints

#### GET /api/metadata/tables
Get all tables with their metadata (columns, primary keys, foreign keys).

**Response:**
```json
[
  {
    "schemaName": "ppdg3p",
    "tableName": "PPDG3P",
    "tableType": "BASE TABLE",
    "columns": [
      {
        "columnName": "ID",
        "dataType": "int",
        "maxLength": null,
        "numericPrecision": 10,
        "numericScale": 0,
        "isNullable": false,
        "isIdentity": true,
        "isPrimaryKey": true,
        "defaultValue": null,
        "ordinalPosition": 1
      }
    ],
    "foreignKeys": [
      {
        "constraintName": "FK_PPDG3P_OrgPU",
        "columnName": "IDOrganaPoreske",
        "referencedSchema": "ppdg3p",
        "referencedTable": "OrgPU",
        "referencedColumn": "ID",
        "deleteRule": "NO_ACTION",
        "updateRule": "NO_ACTION"
      }
    ],
    "primaryKeyColumns": ["ID"]
  }
]
```

#### GET /api/metadata/views
Get all views with their column metadata.

#### GET /api/metadata/tables/{tableName}
Get metadata for a specific table or view.

#### GET /api/metadata/procedures
Get list of available stored procedures.

---

### 2. Generic Table CRUD Endpoints

#### GET /api/table/{tableName}
Get all rows from a table.

**Query Parameters:**
- `top` (int, optional): Limit number of rows
- `offset` (int, optional): Skip rows (requires orderBy)
- `orderBy` (string, optional): Column name to sort by
- `orderDir` (string, optional): "ASC" or "DESC" (default: "ASC")

**Example:**
```
GET /api/table/PPDG3P?top=10&orderBy=ID&orderDir=DESC
```

**Response:**
```json
{
  "rows": [
    {
      "ID": 1,
      "DatumOstvarivanjaPrihoda": "2024-01-15",
      "IDPoreskogObveznika": 1234567890123
    }
  ],
  "totalCount": 1,
  "affectedRows": 0
}
```

#### GET /api/table/{tableName}/find
Find row(s) by key values.

**Query Parameters:** Pass key columns as query params.

**Example:**
```
GET /api/table/PoreskiObveznik/find?JMBG/ESB/PIB_lice=1234567890123
```

#### POST /api/table/{tableName}
Insert a new row.

**Request Body:**
```json
{
  "values": {
    "Naziv": "Test Organization",
    "IDPrijave": 1
  }
}
```

**Response:**
```json
{
  "affectedRows": 1,
  "insertedRow": {
    "ID": 5,
    "Naziv": "Test Organization",
    "IDPrijave": 1
  }
}
```

#### PUT /api/table/{tableName}
Update an existing row.

**Request Body:**
```json
{
  "keys": {
    "ID": 5
  },
  "values": {
    "Naziv": "Updated Name"
  }
}
```

**Response:**
```json
{
  "affectedRows": 1
}
```

#### DELETE /api/table/{tableName}
Delete a row.

**Request Body:**
```json
{
  "keys": {
    "ID": 5
  }
}
```

#### POST /api/table/procedure/{procedureName}
Execute a stored procedure.

**Request Body:**
```json
{
  "IDPrijave": 1
}
```

---

### 3. KDT (Specialization/Table-per-subtype) Endpoints

The database has several KDT hierarchies where one entity is split across parent-child tables:

| Hierarchy Name | Parent Table | Child Tables |
|---------------|--------------|--------------|
| Lice | Lice | Fizicko, Pravno, Broker |
| StavkaUmanjenja | StavkaUmanjenja | KapitalniGubitak, UlaganjeUOsnKap, UlaganjneUResavanjeSP |
| StavkaPrenosa | StavkaPrenosa | PrenosHartijaOdVrednosti |
| PoreskiObveznik | PoreskiObveznik | PoreskiObveznik_Details |

#### GET /api/kdt/hierarchies
Get all defined KDT hierarchies.

**Response:**
```json
[
  {
    "name": "Lice",
    "parentTable": "Lice",
    "parentKeyColumn": "JMBG/ESB/PIB",
    "childTables": [
      {
        "tableName": "Fizicko",
        "foreignKeyColumn": "JMGB/ESB/PIB_lice",
        "typeDiscriminator": "FIZICKO"
      }
    ]
  }
]
```

#### GET /api/kdt/{hierarchyName}
Get all records from a KDT hierarchy with type indicators.

**Example:**
```
GET /api/kdt/Lice
```

#### GET /api/kdt/{hierarchyName}/{keyValue}
Get a specific record with all its child data.

**Example:**
```
GET /api/kdt/Lice/1234567890123
```

**Response:**
```json
{
  "parent": {
    "JMBG/ESB/PIB": 1234567890123,
    "Telefon": "+381...",
    "Email": "test@test.com"
  },
  "type": "FIZICKO",
  "children": {
    "Fizicko": {
      "JMGB/ESB/PIB_lice": 1234567890123,
      "Ime": "Petar",
      "Prezime": "Petrovic"
    }
  }
}
```

#### POST /api/kdt/{hierarchyName}/{childType}
Insert into parent and child tables in a transaction.

**Example:**
```
POST /api/kdt/StavkaUmanjenja/KAP_GUB
```

**Request Body:**
```json
{
  "parentValues": {
    "DatumUlaganja": "2024-01-15",
    "IDPrijave": 1
  },
  "childValues": {
    "IznosKapGub": 50000,
    "BrojResenja": 12345
  }
}
```

#### PUT /api/kdt/{hierarchyName}/{childType}
Update parent and/or child tables.

**Request Body:**
```json
{
  "keys": {
    "ID": 5
  },
  "parentValues": {
    "DatumUlaganja": "2024-02-20"
  },
  "childValues": {
    "IznosKapGub": 75000
  }
}
```

#### DELETE /api/kdt/{hierarchyName}
Delete from parent and all child tables.

**Request Body:**
```json
{
  "keys": {
    "ID": 5
  }
}
```

---

### 4. Document Endpoints (PPDG3P Forms)

These endpoints work with the main PPDG3P documents using the database view and stored procedures.

#### GET /api/document
Get all PPDG3P documents as JSON.

**Response:**
```json
[
  {
    "id": 1,
    "document": {
      "idPrijave": 1,
      "datumOstvarivanjaPrihoda": "2024-01-15",
      "poreskiObveznik": {
        "id": 1234567890123,
        "ime": "Petar",
        "prezime": "Petrovic"
      },
      "Prenosi": [...],
      "Umanjenja": [...],
      "Dokazi": [...]
    }
  }
]
```

#### GET /api/document/{id}
Get a specific document.

#### POST /api/document
Create a new PPDG3P document.

**Request Body:**
```json
{
  "datumOstvarivanjaPrihoda": "2024-01-15",
  "datumDospelostiZaPodnosenjePrijave": "2024-02-15",
  "datumNacinPodnosenjaPrijave": "2024-01-20",
  "izmena": false,
  "idOrganaPoreske": 1,
  "idPoreskogObveznika": 1234567890123,
  "idVrstePrijave": 1,
  "idOsnovaZaPrijavu": 1,
  "email": "optional@email.com"
}
```

#### PUT /api/document/{id}
Full update using UpsertPPDG3PDocumentFromJson stored procedure (Sync=true).

**Request Body:** Full JSON document matching the view structure.

#### PATCH /api/document/{id}
Partial update (Sync=false) - only provided fields are updated.

#### DELETE /api/document/{id}
Delete a document (cascades to related tables).

#### POST /api/document/{id}/recalculate
Recalculate totals (UkProdajnaCena, UkNabavnaCena, UkUmanjenja, KapitalnaOsnovica).

---

## Database Schema Reference

### Tables

| Table | Description | Primary Key |
|-------|-------------|-------------|
| PPDG3P | Main tax form | ID (identity) |
| PoreskiObveznik | Tax payer | JMBG/ESB/PIB_lice |
| PoreskiObveznik_Details | Tax payer details | JMBG/ESB/PIB |
| Lice | Person/Entity base | JMBG/ESB/PIB |
| Fizicko | Natural person | JMGB/ESB/PIB_lice |
| Pravno | Legal entity | JMGB/ESB/PIB_lice |
| Broker | Broker | JMGB/ESB/PIB_lice |
| OrgPU | Tax authority org | ID (identity) |
| VrstaPrijave | Application type | ID (identity) |
| OsnovZaPrijavu | Application basis | ID (identity) |
| Punomocnik | Attorney | JMBG/ESB/PIB_lice, IDPrijave |
| Dokazi | Evidence/proofs | BrojDokaza (identity) |
| StavkaPrenosa | Transfer item | ID (identity) |
| PrenosHartijaOdVrednosti | Securities transfer | IDStavkePrenosa |
| DokumentOSticanju | Acquisition document | ID (identity) |
| StavkaUmanjenja | Reduction item base | ID (identity) |
| KapitalniGubitak | Capital loss | IDStavkeUmanjenja |
| UlaganjeUOsnKap | Capital investment | IDStavkeUmanjenja |
| UlaganjneUResavanjeSP | Housing investment | IDStavkeUmanjenja |

### Views

| View | Description |
|------|-------------|
| vw_PPDG3P_Document | Full PPDG3P document as JSON |

### Stored Procedures

| Procedure | Description | Parameters |
|-----------|-------------|------------|
| PPDG3P_OsnovicaCalc | Recalculate totals | @IDPrijave int |
| UpsertPPDG3PDocumentFromJson | Upsert from JSON | @IDPrijave int, @JsonDoc nvarchar(max), @Sync bit |

---

## Frontend Implementation Notes

### 1. Data Grid Component
- Use `/api/metadata/tables/{tableName}` to get column definitions
- Use `isIdentity` to mark auto-generated fields (don't include in insert forms)
- Use `isPrimaryKey` to identify key columns for update/delete
- Use `foreignKeys` to create dropdown lookups

### 2. Form Component
- Do NOT add client-side validation
- Allow all input values
- Send data as-is to the API
- Display database errors in an error panel

### 3. KDT/Specialization Forms
- When editing a KDT entity, first call `/api/kdt/{hierarchy}/{key}` to get type
- Show appropriate child fields based on type
- Use KDT endpoints for insert/update to handle both tables atomically

### 4. Error Display
```jsx
// Example error display component
function ErrorPanel({ error }) {
  if (!error) return null;

  if (error.type === 'SqlException') {
    return (
      <div className="error-panel">
        <h3>Database Error</h3>
        {error.errors.map((e, i) => (
          <div key={i}>
            <strong>Error {e.errorNumber}:</strong> {e.message}
            {e.procedure && <div>Procedure: {e.procedure}</div>}
            <div>Line: {e.lineNumber}</div>
          </div>
        ))}
      </div>
    );
  }

  return <div className="error-panel">{error.detail}</div>;
}
```

### 5. Lookup Tables
The following tables are typically used as lookups (foreign key references):
- `OrgPU` - Tax authority organizations
- `VrstaPrijave` - Application types
- `OsnovZaPrijavu` - Application bases
- `PoreskiObveznik` - Tax payers

### 6. Handling Special Column Names
Some columns contain special characters (e.g., `JMBG/ESB/PIB_lice`). URL encode these when passing as query parameters.

---

## Running the API

```bash
cd Backend/PPDG3P.Api
dotnet run
```

Swagger UI available at: `http://localhost:5000/swagger`

### Configuration
Edit `appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=PPdb;Trusted_Connection=True;TrustServerCertificate=True;"
  },
  "DatabaseSchema": "ppdg3p"
}
```
