# Validation Removal Examples

This file contains before/after examples for removing validations across different layers.

## Frontend Examples

### Example 1: HTML5 Required Attribute

**Before:**
```tsx
<input
  type="text"
  value={formData.ime}
  onChange={(e) => setFormData(prev => ({ ...prev, ime: e.target.value }))}
  required
/>
```

**After:**
```tsx
<input
  type="text"
  value={formData.ime}
  onChange={(e) => setFormData(prev => ({ ...prev, ime: e.target.value }))}
/>
```

### Example 2: Email Input Type

**Before:**
```tsx
<input
  type="email"
  value={formData.email}
  onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
  required
/>
```

**After:**
```tsx
<input
  type="text"
  value={formData.email}
  onChange={(e) => setFormData(prev => ({ ...prev, email: e.target.value }))}
/>
```

### Example 3: Pattern Validation

**Before:**
```tsx
<input
  type="text"
  pattern="[0-9]+"
  value={formData.jmbg}
  onChange={(e) => setFormData(prev => ({ ...prev, jmbg: e.target.value }))}
  required
  title="Унесите само бројеве"
/>
```

**After:**
```tsx
<input
  type="text"
  value={formData.jmbg}
  onChange={(e) => setFormData(prev => ({ ...prev, jmbg: e.target.value }))}
/>
```

### Example 4: Select with Required

**Before:**
```tsx
<select
  value={formData.organPU}
  onChange={(e) => setFormData(prev => ({ ...prev, organPU: parseInt(e.target.value) }))}
  required
>
  <option value="">-- Изаберите --</option>
  {options.map(o => <option key={o.id} value={o.id}>{o.naziv}</option>)}
</select>
```

**After:**
```tsx
<select
  value={formData.organPU}
  onChange={(e) => setFormData(prev => ({ ...prev, organPU: parseInt(e.target.value) }))}
>
  <option value="">-- Изаберите --</option>
  {options.map(o => <option key={o.id} value={o.id}>{o.naziv}</option>)}
</select>
```

### Example 5: JavaScript Validation Logic

**Before:**
```typescript
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();

  // Validate JMBG is a valid number
  const jmbgNumber = parseInt(formData.jmbgObveznika);
  if (isNaN(jmbgNumber)) {
    setError({
      type: 'ArgumentException',
      title: 'Validation Error',
      status: 400,
      detail: 'ЈМБГ/ЕСБ/ПИБ мора бити валидан број'
    });
    return;
  }

  // Submit data
  await api.create(formData);
};
```

**After:**
```typescript
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();

  // Convert JMBG to number - database will validate if invalid
  const jmbgNumber = parseInt(formData.jmbgObveznika);

  // Submit data - database constraints will catch errors
  await api.create(formData);
};
```

### Example 6: Number Input with Min/Max

**Before:**
```tsx
<input
  type="number"
  min={0}
  max={100}
  step={0.01}
  value={formData.povrsina}
  onChange={(e) => updateField('povrsina', parseFloat(e.target.value))}
  required
/>
```

**After:**
```tsx
<input
  type="number"
  value={formData.povrsina}
  onChange={(e) => updateField('povrsina', parseFloat(e.target.value))}
/>
```

## Backend Examples

### Example 7: Model with Data Annotations

**Before:**
```csharp
public class CreateDocumentRequest
{
    [Required]
    public DateTime DatumOstvarivanjaPrihoda { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int IDOrganaPoreske { get; set; }

    [Required]
    [Range(1, long.MaxValue)]
    public long IDPoreskogObveznika { get; set; }

    [EmailAddress]
    [MaxLength(255)]
    public string? Email { get; set; }
}
```

**After:**
```csharp
public class CreateDocumentRequest
{
    public DateTime DatumOstvarivanjaPrihoda { get; set; }
    public int IDOrganaPoreske { get; set; }
    public long IDPoreskogObveznika { get; set; }
    public string? Email { get; set; }
}
```

### Example 8: Controller with ModelState Check

**Before:**
```csharp
[HttpPost]
public async Task<IActionResult> Create([FromBody] CreateDocumentRequest request)
{
    if (!ModelState.IsValid)
    {
        return BadRequest(ModelState);
    }

    // Process request
    var result = await _service.CreateDocument(request);
    return Ok(result);
}
```

**After:**
```csharp
[HttpPost]
public async Task<IActionResult> Create([FromBody] CreateDocumentRequest request)
{
    // Database constraints will validate - no need for ModelState check
    var result = await _service.CreateDocument(request);
    return Ok(result);
}
```

### Example 9: Manual Validation in Controller

**Before:**
```csharp
[HttpPost]
public async Task<IActionResult> Create([FromBody] CreateDocumentRequest request)
{
    // Manual validation
    if (request.IDOrganaPoreske <= 0)
    {
        return BadRequest(new { Message = "Invalid organ ID" });
    }

    if (string.IsNullOrWhiteSpace(request.Email))
    {
        return BadRequest(new { Message = "Email is required" });
    }

    if (!IsValidEmail(request.Email))
    {
        return BadRequest(new { Message = "Invalid email format" });
    }

    var result = await _service.CreateDocument(request);
    return Ok(result);
}
```

**After:**
```csharp
[HttpPost]
public async Task<IActionResult> Create([FromBody] CreateDocumentRequest request)
{
    // All validation removed - database will enforce constraints
    var result = await _service.CreateDocument(request);
    return Ok(result);
}
```

## What Happens at the Database

When invalid data reaches the database, constraints enforce validation:

### NOT NULL Constraint Violation

**SQL Error:**
```
Cannot insert the value NULL into column 'IDOrganaPoreske', table 'PPDG3P.ppdg3p.PPDG3P_Details'; column does not allow nulls. INSERT fails.
```

**Middleware Translation:**
```json
{
  "type": "SqlException",
  "title": "Database Constraint Violation",
  "status": 400,
  "detail": "IDOrganaPoreske is required"
}
```

### CHECK Constraint Violation

**SQL Error:**
```
The INSERT statement conflicted with the CHECK constraint "CK_PoreskiObveznik_JMBG". The conflict occurred in database "PPDG3P", table "ppdg3p.PoreskiObveznik", column 'JMBG/ESB/PIB_lice'.
```

**Middleware Translation:**
```json
{
  "type": "SqlException",
  "title": "Database Constraint Violation",
  "status": 400,
  "detail": "JMBG/ESB/PIB must be a valid number"
}
```

### Foreign Key Constraint Violation

**SQL Error:**
```
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_PPDG3P_Details_OrgPU". The conflict occurred in database "PPDG3P", table "ppdg3p.OrgPU", column 'ID'.
```

**Middleware Translation:**
```json
{
  "type": "SqlException",
  "title": "Database Constraint Violation",
  "status": 400,
  "detail": "Invalid organ reference - organ does not exist"
}
```

## Keep These (NOT Validation)

These attributes/features should **stay** as they serve different purposes:

### Visual Indicators
```tsx
<label>
  2.2 ЈМБГ/ЕСБ/ПИБ *  {/* Asterisk is OK - it's visual, not validation */}
</label>
```

### Binding Attributes
```csharp
[HttpPost]  // Routing - keep
public async Task<IActionResult> Create([FromBody] CreateDocumentRequest request)  // Binding - keep
```

### Type Hints
```tsx
<input type="number" />  {/* Type is OK - helps keyboard on mobile */}
<input type="date" />    {/* Date picker is OK */}
```

### Data Transformation
```typescript
// OK to keep - this is transformation, not validation
const jmbgNumber = parseInt(formData.jmbgObveznika);
const date = new Date(formData.datum);
```
