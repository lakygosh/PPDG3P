---
name: disable-validations
description: Disable frontend and backend validations for university projects that require database-level validation only
disable-model-invocation: true
allowed-tools: Read, Edit, Grep, Glob, TaskCreate, TaskUpdate, TaskList
---

# Disable Validations Skill

**Purpose:** Remove all frontend and backend validations while preserving database-level constraints. For university projects that require all validation to be enforced at the database layer.

## What This Skill Does

Systematically removes validation logic from your application:

### Frontend Validations (React/TypeScript)
- Remove HTML5 validation attributes: `required`, `pattern`, `type="email"`, `min`, `max`, `minLength`, `maxLength`, `step`
- Remove client-side JavaScript validation logic (manual checks, validation state)
- Change email inputs from `type="email"` to `type="text"`
- Keep visual indicators (asterisks) for UX purposes

### Backend Validations (ASP.NET Core)
- Remove data annotation attributes: `[Required]`, `[StringLength]`, `[MaxLength]`, `[MinLength]`, `[Range]`, `[RegularExpression]`, `[EmailAddress]`, `[Phone]`, `[Url]`, `[Compare]`
- Remove `ModelState.IsValid` checks in controllers
- Remove manual validation logic in controller methods
- Keep routing/binding attributes like `[FromBody]`, `[FromQuery]`, `[Route]`

### Database Validations (PRESERVED)
**DO NOT MODIFY** these database constraints:
- NOT NULL constraints
- CHECK constraints
- UNIQUE constraints
- Foreign key constraints
- Default values
- Triggers
- Stored procedure validations

## Execution Steps

When invoked, perform the following tasks in order:

### Task 1: Remove Frontend HTML5 Validation Attributes

1. **Scan all React/TypeScript files** in `Frontend/src/**/*.{tsx,ts}`

2. **For each form element**, remove these attributes:
   - `required`
   - `pattern`
   - `minLength` / `maxLength`
   - `min` / `max`
   - `step`
   - Change `type="email"` to `type="text"`
   - Change `type="url"` to `type="text"`
   - Remove `title` attributes used for validation hints

3. **Files to check:**
   - `Frontend/src/pages/DocumentFormPage.tsx` - Main PPDG3P document form
   - `Frontend/src/components/RecordForm.tsx` - Generic table record form
   - `Frontend/src/pages/KdtPage.tsx` - KDT hierarchy forms
   - Any other form components

### Task 2: Remove Frontend JavaScript Validation Logic

1. **Find validation logic patterns:**
   - `isNaN()` checks
   - Regex validation (`/pattern/.test()`)
   - Length checks (`if (value.length < min)`)
   - Custom validation functions
   - Error state for validation (`setError()` calls with validation messages)

2. **Remove or simplify:**
   - Remove validation error returns
   - Keep data transformation (e.g., `parseInt()`) but remove validation
   - Allow submission to proceed to backend/database

3. **Example transformation:**
   ```javascript
   // BEFORE
   const jmbgNumber = parseInt(formData.jmbgObveznika);
   if (isNaN(jmbgNumber)) {
     setError({ detail: 'ЈМБГ мора бити валидан број' });
     return;
   }

   // AFTER
   const jmbgNumber = parseInt(formData.jmbgObveznika);
   // Database will validate - continue with submission
   ```

### Task 3: Remove Backend Validation Attributes

1. **Scan all C# files** in `Backend/**/*.cs`

2. **Search for data annotation attributes:**
   ```bash
   grep -r "\[Required\]" Backend/
   grep -r "\[StringLength\]" Backend/
   grep -r "\[Range\]" Backend/
   grep -r "\[EmailAddress\]" Backend/
   ```

3. **Remove these attributes** from model/DTO classes:
   - `[Required]`
   - `[StringLength(...)]`
   - `[MaxLength(...)]`
   - `[MinLength(...)]`
   - `[Range(...)]`
   - `[RegularExpression(...)]`
   - `[EmailAddress]`
   - `[Phone]`
   - `[Url]`
   - `[Compare(...)]`

4. **Keep these attributes** (they're not validation):
   - `[FromBody]`, `[FromQuery]`, `[FromRoute]`, `[FromHeader]`
   - `[HttpGet]`, `[HttpPost]`, `[HttpPut]`, `[HttpDelete]`
   - `[Route(...)]`
   - `[ApiController]`

### Task 4: Remove Backend Validation Logic

1. **Search for ModelState checks:**
   ```bash
   grep -r "ModelState.IsValid" Backend/
   ```

2. **Remove validation blocks:**
   ```csharp
   // BEFORE
   if (!ModelState.IsValid)
   {
       return BadRequest(ModelState);
   }

   // AFTER
   // Removed - database will enforce constraints
   ```

3. **Remove manual validation:**
   - Parameter null checks (database handles NOT NULL)
   - Range validation (database handles CHECK constraints)
   - Format validation (database handles data types)

### Task 5: Report Changes

Generate a summary report showing:

1. **Files Modified:**
   - List each file changed
   - Count of validations removed per file

2. **Validation Types Removed:**
   - HTML5 attributes: count
   - JavaScript validation logic: count
   - Backend attributes: count
   - ModelState checks: count

3. **Database Validations Preserved:**
   - Confirm NOT NULL constraints intact
   - Confirm CHECK constraints intact
   - Confirm FK constraints intact

4. **Testing Recommendations:**
   - Test with invalid data to confirm database rejects it
   - Verify SqlExceptionMiddleware translates errors properly
   - Check that constraint violation messages are user-friendly

## Example Output

```
✅ Validation Removal Complete

Frontend Changes:
- DocumentFormPage.tsx: Removed 9 'required' attributes, 1 'pattern', 1 'type="email"'
- RecordForm.tsx: Removed 1 'maxLength' attribute
- JavaScript validation: Removed JMBG number check

Backend Changes:
- No validation attributes found (already clean)
- No ModelState checks found (already clean)

Database Constraints: ✅ PRESERVED
- NOT NULL constraints: Active
- CHECK constraints: Active
- Foreign key constraints: Active

Next Steps:
1. Test form submission with invalid data
2. Verify database constraint violations are caught
3. Check SqlExceptionMiddleware error messages
```

## Important Notes

- This skill is for **educational/university projects** where database-level validation is required
- **DO NOT use this in production** - layered validation is a best practice
- Database constraints will catch all invalid data
- Your `SqlExceptionMiddleware` will translate database errors to user-friendly messages
- Visual indicators (asterisks on required fields) can stay for UX - they're not validation

## Usage

```bash
# Run the skill
/disable-validations

# Or with context about which files to focus on
/disable-validations Frontend/src/pages/DocumentFormPage.tsx
```
