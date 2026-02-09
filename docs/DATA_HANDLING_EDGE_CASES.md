# Data Handling & Edge Cases Documentation

## Overview

This document outlines all edge cases and data handling scenarios that the HabitWallet application gracefully handles. The app is designed to work flawlessly regardless of API response format or data quality.

---

## Supported API Response Formats

### Categories Endpoint (`/categories`)

The application supports **two distinct response formats**:

#### Format 1: Object Array (Preferred)
```json
[
  {
    "id": "food",
    "name": "Food & Dining",
    "icon": "restaurant",
    "color": 4294198326,
    "updatedAt": "2026-02-09T00:00:00.000Z"
  },
  {
    "id": "transport",
    "name": "Transportation",
    "icon": "directions_car",
    "color": 4278240499,
    "updatedAt": "2026-02-09T00:00:00.000Z"
  }
]
```

#### Format 2: String Array (Simplified)
```json
["Food", "Travel", "Bills", "Shopping", "Salary", "Other"]
```

**Handling Strategy:**
- String arrays are automatically converted to full category objects
- IDs are generated from names (lowercase, spaces replaced with underscores)
- Icons are intelligently mapped based on category name
- Colors are assigned from a predefined palette using hash-based selection

### Transactions Endpoint (`/transactions`)

The application expects **object array format**:

```json
[
  {
    "id": "tx-init-001",
    "amount": -65.20,
    "category": "food",
    "ts": "2026-02-08T19:30:00.000Z",
    "note": "Dinner at the bistro",
    "updatedAt": "2026-02-09T01:00:00.000Z"
  },
  {
    "id": "tx-init-002",
    "amount": 3200.00,
    "category": "salary",
    "ts": "2026-02-01T09:00:00.000Z",
    "note": "Main Salary Credit",
    "updatedAt": "2026-02-09T01:00:00.000Z"
  }
]
```

---

## Edge Cases Handled

### 1. Network & API Response Issues

| Scenario | Handling Strategy |
|----------|------------------|
| **Network timeout** | Returns empty list, UI shows appropriate empty state |
| **500 Server Error** | Returns empty list, error is logged but not shown to user |
| **Null response** | Returns empty list |
| **Non-array response** | Returns empty list |
| **Empty array `[]`** | Returns empty list, UI shows "No data" message |

### 2. Category Data Edge Cases

| Scenario | Handling Strategy |
|----------|------------------|
| **Null item in array** | Skipped silently |
| **Empty string `""`** | Skipped after trimming |
| **Whitespace-only string** | Skipped after trimming |
| **Missing `id` field** | Skipped silently |
| **Null `id` field** | Skipped silently |
| **Malformed object** | Skipped silently, parsing error caught |
| **Unknown category name** | Mapped to generic "category" icon |
| **Mixed format array** | Each item processed according to its type |

#### Category Name to Icon Mapping

The following category names are automatically mapped to appropriate icons:

```dart
'food' → 'restaurant'
'dining' → 'restaurant'
'groceries' → 'shopping_cart'
'transport' → 'directions_car'
'transportation' → 'directions_car'
'travel' → 'flight'
'bills' → 'receipt'
'utilities' → 'receipt'
'shopping' → 'shopping_bag'
'salary' → 'payments'
'income' → 'payments'
'entertainment' → 'movie'
'health' → 'local_hospital'
'medical' → 'local_hospital'
'education' → 'school'
'other' → 'category'
'others' → 'category'
```

Any unrecognized category defaults to `'category'` icon.

### 3. Transaction Data Edge Cases

| Scenario | Handling Strategy |
|----------|------------------|
| **Null item in array** | Skipped silently |
| **Missing `id` field** | Skipped silently |
| **Missing `amount` field** | Skipped silently |
| **Missing `category` field** | Skipped silently |
| **Missing `ts` field** | Skipped silently |
| **Null required field** | Skipped silently |
| **Invalid date format** | Parsing error caught, transaction skipped |
| **Non-numeric amount** | Parsing error caught, transaction skipped |
| **Zero amount** | Accepted (valid neutral transaction) |
| **Malformed object** | Skipped silently, parsing error caught |

### 4. Category-Transaction Relationship Edge Cases

| Scenario | Handling Strategy |
|----------|------------------|
| **Transaction references non-existent category** | Fallback category created with formatted name |
| **Category ID is snake_case** | Formatted to "Title Case" (e.g., `food_dining` → "Food Dining") |
| **Category ID is kebab-case** | Formatted to "Title Case" (e.g., `food-dining` → "Food Dining") |
| **Category ID is single word** | Capitalized (e.g., `food` → "Food") |
| **Orphaned transaction** | Displayed with gray color and help icon |

#### Orphaned Transaction Handling

When a transaction references a category that doesn't exist:

```dart
CategorySpend(
  categoryId: 'unknown_category',
  categoryName: 'Unknown Category',  // Auto-formatted
  categoryIcon: 'help_outline',      // Help icon
  categoryColor: 0xFF9E9E9E,         // Gray color
  amount: 120.00,
  percentage: 15.5,
)
```

### 5. Analytics & Aggregation Edge Cases

| Scenario | Handling Strategy |
|----------|------------------|
| **No transactions** | Shows "No transactions to analyze" message |
| **No expenses** | Category breakdown returns empty list |
| **All income, no expenses** | Total expense = 0, savings rate = 100% |
| **All expenses, no income** | Savings rate = 0%, shows deficit |
| **Zero total income** | Savings rate = 0% (avoids division by zero) |
| **More than 5 categories** | Top 5 shown, rest grouped as "Others" |
| **Exactly 5 categories** | All shown individually |
| **Less than 5 categories** | All shown individually |

### 6. UI Display Edge Cases

| Scenario | Handling Strategy |
|----------|------------------|
| **Very long category name** | Truncated with ellipsis (`maxLines: 1`) |
| **Very large amount** | Formatted as compact (e.g., "1.2M", "45.5K") |
| **Very small amount** | Displayed with 2 decimal places |
| **Negative percentage** | Not possible (validation ensures positive) |
| **Percentage > 100%** | Not possible (calculated from total) |
| **Empty category list** | Chart shows empty state |
| **Empty transaction list** | Shows appropriate empty state message |

---

## Data Validation Rules

### Required Fields

#### Transaction Entity
- ✅ `id` (String, non-null, non-empty)
- ✅ `amount` (double, non-null, can be zero)
- ✅ `category` (String, non-null, non-empty)
- ✅ `ts` (DateTime, non-null, valid ISO 8601)
- ⚪ `note` (String?, optional)
- ⚪ `updatedAt` (DateTime?, optional)

#### Category Entity
- ✅ `id` (String, non-null, non-empty)
- ✅ `name` (String, non-null, non-empty)
- ✅ `icon` (String, non-null, defaults to 'category')
- ✅ `color` (int, non-null, defaults from palette)
- ⚪ `updatedAt` (DateTime?, optional)

---

## Error Recovery Strategies

### 1. Silent Failure
**Used for:** Individual malformed items in arrays

**Rationale:** One bad item shouldn't break the entire list. Users see valid data.

**Example:**
```dart
// Input: [validItem, malformedItem, validItem]
// Output: [validItem, validItem]
// User sees: 2 items (malformed item silently skipped)
```

### 2. Empty State
**Used for:** Complete API failures, empty responses

**Rationale:** Clear communication that no data is available.

**Example:**
```dart
// Input: Network error
// Output: []
// User sees: "No transactions to analyze" message
```

### 3. Fallback Values
**Used for:** Missing optional fields, orphaned relationships

**Rationale:** Provide best-effort display with sensible defaults.

**Example:**
```dart
// Transaction references "unknown_category"
// Fallback: Create category with formatted name, gray color, help icon
```

---

## Testing Scenarios

### Recommended Test Cases

1. **Normal Operation**
   - Valid object array for categories
   - Valid object array for transactions
   - All relationships intact

2. **Format Variations**
   - String array for categories
   - Mixed case category names
   - Various date formats

3. **Edge Cases**
   - Empty arrays
   - Null responses
   - Missing required fields
   - Orphaned transactions
   - Very large datasets (1000+ items)

4. **Error Conditions**
   - Network timeout
   - 500 server error
   - Malformed JSON
   - Invalid data types

5. **UI Stress Tests**
   - Very long category names
   - Very large amounts (millions)
   - Very small amounts (cents)
   - Many categories (>10)

---

## Performance Considerations

### Background Processing

Heavy computations are offloaded to background isolates:

```dart
// Analytics aggregation runs in separate isolate
return compute(_aggregateData, _AggregationParams(transactions, period));

// Financial summary calculation runs in separate isolate
return Isolate.run(() {
  const aggregator = FinancialAggregator();
  return aggregator.aggregate(...);
});
```

### Caching Strategy

- Riverpod providers automatically cache results
- Data is only re-fetched when explicitly invalidated
- UI rebuilds are minimized through proper state management

---

## Best Practices for API Developers

If you're building the backend API, follow these guidelines:

### 1. Prefer Object Format
Always return full objects with all fields:

```json
{
  "id": "food",
  "name": "Food & Dining",
  "icon": "restaurant",
  "color": 4294198326,
  "updatedAt": "2026-02-09T00:00:00.000Z"
}
```

### 2. Ensure Data Consistency
- Every transaction should reference a valid category
- Category IDs should be stable and not change
- Use lowercase IDs with underscores (e.g., `food_dining`)

### 3. Validate Before Sending
- Ensure all required fields are present
- Validate data types match schema
- Remove null items from arrays

### 4. Use ISO 8601 for Dates
```json
"ts": "2026-02-08T19:30:00.000Z"
```

### 5. Return Empty Arrays, Not Null
```json
// ✅ Good
{ "transactions": [] }

// ❌ Bad
{ "transactions": null }
```

---

## Conclusion

The HabitWallet application is built with **defensive programming** principles:

- ✅ **Graceful degradation** - Works with partial data
- ✅ **Silent error recovery** - Doesn't crash on bad data
- ✅ **Flexible input** - Accepts multiple formats
- ✅ **Sensible defaults** - Provides fallbacks when needed
- ✅ **Clear communication** - Shows appropriate empty states
- ✅ **Performance optimized** - Background processing for heavy tasks

**The app will work like a charm in any scenario!** 🎯
