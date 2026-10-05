# PPDG3P – Capital Gains Tax Return Database App

A full-stack database application for the Serbian PPDG3P capital gains tax return, built on SQL Server with raw ADO.NET (no ORM) and a React UI.

![C#](https://img.shields.io/badge/C%23-239120?style=flat-square&logo=csharp&logoColor=white)
![.NET 8](https://img.shields.io/badge/.NET-8.0-512BD4?style=flat-square&logo=dotnet&logoColor=white)
![ASP.NET Core](https://img.shields.io/badge/ASP.NET_Core-Web_API-512BD4?style=flat-square&logo=dotnet&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL_Server-T--SQL-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![React 19](https://img.shields.io/badge/React-19-61DAFB?style=flat-square&logo=react&logoColor=black)
![TypeScript](https://img.shields.io/badge/TypeScript-5.9-3178C6?style=flat-square&logo=typescript&logoColor=white)
![Vite](https://img.shields.io/badge/Vite-7-646CFF?style=flat-square&logo=vite&logoColor=white)

<!-- TODO: add screenshot of the document form / table editor -->

## Overview

This is a university database course project. It models the PPDG3P tax form (the return used in Serbia to report capital gains and losses on transfers of property and securities) as a normalized SQL Server schema, then puts a web UI on top of it.

The course rules shaped the design. The app may only talk to the database through hand-written SQL (ORMs, including Dapper, were not allowed), and it may not validate anything itself. Every constraint is enforced by the database, and the UI shows SQL Server's error messages exactly as the server returns them.

## Features

- **Full tax-return editor.** Create, edit and delete a complete PPDG3P return (header, taxpayer, transfer items, securities, acquisition documents, deductions, proxy, supporting evidence) on a single form.
- **Generic table and view browser.** Data grid plus insert/update/delete forms for each table in the `ppdg3p` schema.
- **Specialization (table-per-subtype) handling.** Manages entities that are split across a parent table and subtype tables, e.g. `Lice` → `Fizicko` / `Pravno` / `Broker`.
- **Verbatim database errors.** A dedicated error panel shows the SQL Server error number, message, procedure, line, state and severity.
- **Server-side recalculation.** Totals and the capital gains tax base are recomputed by a stored procedure.
- **Swagger UI** for exploring the API in development.

## Tech Stack

| Layer      | Technology                                                                   |
|------------|------------------------------------------------------------------------------|
| Database   | Microsoft SQL Server (Express), T-SQL: views, stored procedures, triggers, `FOR JSON` / `OPENJSON` |
| Backend    | ASP.NET Core Web API on .NET 8, ADO.NET (`Microsoft.Data.SqlClient`), Swashbuckle |
| Frontend   | React 19, TypeScript, Vite, React Router, Axios                              |

## Technical Highlights

- **No ORM, parameterized SQL only.** All data access uses `SqlConnection` / `SqlCommand` / `SqlDataReader`. Values are always passed as parameters. Table and column names in the generic endpoints are checked against `INFORMATION_SCHEMA` metadata before any SQL is built.
- **Metadata-driven API.** `MetadataService` reads columns, primary keys, foreign keys and identity flags from the system catalog. The generic `TableController` and the React `RecordForm` / `DataGrid` components use that metadata, so no per-table UI code is needed.
- **Document as JSON, stored relationally.** The `vw_PPDG3P_Document` view uses nested `FOR JSON PATH` to build a full return as one JSON document. The `UpsertPPDG3PDocumentFromJson` procedure reads that JSON back (`OPENJSON`, `MERGE`) and writes it across more than a dozen tables in one transaction, with custom `THROW` error codes. The API passes the JSON through and the database does the work.
- **Transactional subtype writes.** `KdtController` inserts and updates a parent row and its subtype row in one `SqlTransaction`, using `SCOPE_IDENTITY()` to pass the generated key from parent to child.
- **Central SQL error mapping.** `SqlExceptionMiddleware` catches every `SqlException` and turns each `SqlError` into a structured JSON response. Controllers have no try/catch for database errors.
- **Database-side logic.** The script includes CHECK constraints, a trigger (`trg_Dokazi_SetJMBG`) that coordinates with the upsert procedure through `SESSION_CONTEXT`, a covering index, and a `Seed_PPDG3P_Bulk` procedure that generates thousands of realistic test returns.

## Getting Started

### Prerequisites

- .NET 8 SDK
- Node.js 20+ and npm
- SQL Server (the project targets a local `SQLEXPRESS` instance) and SSMS or `sqlcmd`

### 1. Create the database

Run `DBScripts/DBScript.sql`. It creates the `PPdb` database, the `ppdg3p` schema, and all tables, views, procedures and the trigger.

> The script contains absolute `.mdf` / `.ldf` paths for a SQL Server 2025 (`MSSQL17`) Express install. Change the `FILENAME` values in the `CREATE DATABASE` statement if your instance is installed elsewhere.

Optional: load sample data:

```sql
EXEC ppdg3p.Seed_PPDG3P_Bulk @N = 500;
```

### 2. Run the API

Edit `ConnectionStrings:DefaultConnection` in `Backend/PPDG3P.Api/appsettings.json` if you are not using `localhost\SQLEXPRESS` with Windows authentication. Then run:

```bash
cd Backend/PPDG3P.Api
dotnet run --launch-profile http
```

The API runs at `http://localhost:5000`, with Swagger UI at `http://localhost:5000/swagger`.

### 3. Run the frontend

```bash
cd Frontend
npm install
npm run dev
```

Open `http://localhost:5173`. The frontend calls the API at `http://localhost:5000/api`, and CORS allows ports 5173 and 3000.

Full endpoint reference: [`Backend/API_DOCUMENTATION.md`](Backend/API_DOCUMENTATION.md).

## Project Structure

```
PPDG3P/
├── Backend/
│   ├── API_DOCUMENTATION.md      # Endpoint reference
│   └── PPDG3P.Api/
│       ├── Controllers/          # Document, KDT, Metadata, generic Table
│       │   └── Tables/           # Explicit per-table CRUD controllers
│       ├── Services/             # SqlService, MetadataService (ADO.NET)
│       ├── Middleware/           # SqlExceptionMiddleware
│       ├── Models/               # DTOs, metadata and error models
│       └── Program.cs
├── DBScripts/
│   └── DBScript.sql              # Full schema, views, procedures, trigger
└── Frontend/
    └── src/
        ├── api/                  # Axios client
        ├── components/           # DataGrid, RecordForm, ErrorPanel, Layout
        └── pages/                # Dashboard, Documents, DocumentForm, TablePage
```

## Author

**Lazar Gošić** — GitHub [@lakygosh](https://github.com/lakygosh)
