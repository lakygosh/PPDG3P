
> You are a senior full-stack engineer and database-aware UI developer.
> I am building a **database UI application** for an academic project.
>
> ## Context
>
> I have a Microsoft SQL Server database with multiple related tables, views, foreign keys, and specialization tables (table-per-subtype / KDT pattern).
>
> ⚠️ **Important constraints (must be strictly followed):**
>
> 1. The application **must access the database only by sending raw SQL commands**.
> 2. **ORMs are strictly forbidden** (e.g. Entity Framework, Hibernate, JPA, Dapper, Sequelize, etc.).
> 3. The application **must not contain additional validations**:
>
> * Do NOT block input values in the UI
> * Do NOT restrict edits to fields
> * Do NOT enforce business rules in the app
> * Let the database constraints decide and return errors
>
> 4. **All database error messages must be shown to the user exactly as returned by the DBMS**.
> 5. The UI must support:
>
> * Viewing data
> * Inserting data
> * Updating data
> * Deleting data
> * Working with both tables and views
>
> 6. Special attention must be paid to **object-relational (KDT / specialization) tables**, where one logical entity is split across multiple related tables.
>
> ## Technology stack (fixed)
>
> * Backend: **ASP.NET Core Web API**
> * Database access: **ADO.NET only** (`SqlConnection`, `SqlCommand`, `SqlDataReader`)
> * Frontend: **React** (I will do it in the separate project)
> * Development environment: **VS Code**
>
> ## Database schema
>
> I will paste the full SQL DDL script of the database here:
>
> ```sql
> -- PATH: DBScripts\DBScript.sql
> ```
>
> ## What I want you to build
>
> ### 1. Backend (ASP.NET Core API)
>
> * A minimal, clean ASP.NET Core Web API project
> * No ORM usage of any kind
> * Generic SQL-based endpoints that:
> * Read table/view metadata
> * Execute SELECT queries
> * Execute INSERT / UPDATE / DELETE operations
> * Use parameterized SQL for values
> * Whitelist table and column names using system catalog views (`sys.tables`, `sys.columns`, `INFORMATION_SCHEMA`) (I am only using PPDG3P IDK if you need sys)
> * Catch `SqlException` and return **full error details**:
> * error number
> * message
> * procedure (if available)
> * line number
>
> ### 2. Frontend (React) (I will build it in the separate project, dont do anything here) 
>
> * A simple CRUD-style UI
> * Table/grid view for displaying data
> * Forms for insert/update (no field restrictions)
> * Buttons for delete
> * A dedicated **error panel** that displays database error messages verbatim
> * UI must work for both tables and views
>
> ### 3. Object-relational (KDT) tables
>
> * Provide a clear UI and API approach for working with specialization tables
> * Do not hide database errors when foreign keys or constraints fail
> * Let the database enforce integrity rules
>
> ## Output format
>
> Please provide:
>
> 1. A short architecture explanation
> 2. Backend project structure
> 3. Example controllers and ADO.NET helpers
> 4. Example SQL execution flow
> 5. React UI structure and main components *DONT*
> 6. Notes on common pitfalls and how to avoid violating the constraint
7. Comperhansive API dokumentation for the next AI model to make REACT forntend
>
> Do NOT include ORM-based solutions.
> Focus on correctness, transparency, and compliance with the rules.

---

