# Children Visibility Issue - Analysis & Fix

**Issue:** When a health worker adds a child for a mother, the child does not appear in the mother's patient app.

**Date:** 2026-02-08

---

## Root Cause Analysis

The issue occurs when there's a mismatch in how children are linked to mothers or when RLS (Row Level Security) policies are not properly configured.

### How It Should Work:

1. **Health Worker Side:**
   - Health worker views a patient (mother) profile
   - Adds a child for that mother
   - Child is saved with `maternal_profile_id` = mother's profile ID

2. **Patient App Side:**
   - Patient logs in with their auth user ID
   - App queries `maternal_profiles` table to get the patient's maternal profile
   - App queries `child_profiles` filtering by `maternal_profile_id`
   - RLS policy checks if the child's `maternal_profile_id` matches any maternal profile owned by the logged-in user

### Potential Issues:

1. **Missing `is_active` field** - Children might be soft-deleted or have NULL `is_active` value
2. **Incorrect RLS policies** - The policy might not be checking the right conditions
3. **Maternal profile mismatch** - The `maternal_profile_id` might not match the logged-in user's profile
4. **Multiple maternal profiles** - A user might have multiple maternal profiles, but only one is being checked

---

## The Fix

### Files Modified:
- `database/fix_patient_view_children.sql` (NEW)

### What the Fix Does:

#### 1. **Ensures `is_active` Column Exists**
```sql
ALTER TABLE child_profiles ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;
```
- Adds the column ifmissing
- Sets existing NULL values to TRUE
- This prevents children from being hidden due to NULL values

#### 2. **Recreates the Patient View Policy**
```sql
CREATE POLICY "Parents can view own children"
ON child_profiles FOR SELECT
USING (
  is_active = TRUE
  AND maternal_profile_id IN (
    SELECT mp.id FROM maternal_profiles mp
    WHERE mp.auth_id = auth.uid()
  )
);
```
**Key Points:**
- Checks `is_active = TRUE` to only show active children
- Uses `IN` subquery to match against ALL maternal profiles for the user
- Uses `auth.uid()` which is the logged-in user's auth ID

#### 3. **Verifies Health Worker Policies**
Ensures health workers can:
- INSERT children for patients in their facility
- VIEW children for patients in their facility

#### 4. **Adds Debug Functions**

**Function: `debug_child_visibility(child_id)`**
- Shows why a specific child may or may not be visible
- Returns maternal profile link details
- Can be called by health workers or admins

**View: `v_child_parent_link`**
- Shows all active children and their mother links
- Useful for bulk debugging

---

## How to Apply the Fix

### Step 1: Run the SQL Script
```bash
# In Supabase SQL Editor, run:
database/fix_patient_view_children.sql
```

### Step 2: Verify the Fix

**Test 1: Check a specific child**
```sql
SELECT * FROM public.debug_child_visibility('<child_id>');
```
This will show:
- Whether the child is active
- The maternal_profile_id
- The mother's auth_id
- Whether the current user can view the child

**Test 2: View all children and their links**
```sql
SELECT * FROM public.v_child_parent_link LIMIT 20;
```

**Test 3: Count children per mother**
```sql
SELECT maternal_profile_id, COUNT(*) as child_count
FROM child_profiles 
WHERE is_active = TRUE
GROUP BY maternal_profile_id;
```

### Step 3: Test in the App

1. **As a Health Worker:**
   - Add a child for a mother
   - Note the mother's name/ID

2. **As the Patient (Mother):**
   - Log into the patient app
   - Go to "My Children" screen
   - The child should now appear

---

## Code Flow Verification

### Health Worker App 
(`add_child_screen.dart` line 76-148):
```dart
final child = ChildProfile(
  id: '',
  maternalProfileId: widget.maternalProfileId, // ✅ Correctly set
  // ... other fields
);

await ref.read(createChildProfileProvider)(child);
```
**Status:** ✅ Working correctly - `maternalProfileId` is properly set

### Patient App 
(`child_provider.dart` line 13-43):
```dart
final patientChildrenProvider = FutureProvider<List<ChildProfile>>((ref) async {
  final maternalProfile = ref.watch(currentMaternalProfileProvider);
  // ...
  final children = await repository.getChildrenByMotherId(maternalProfile.id!);
  return children;
});
```
**Status:** ✅ Working correctly - Queries by maternal_profile_id

### Repository 
(`childbirth_repositories.dart` line 120-135):
```dart
Future<List<ChildProfile>> getChildrenByMotherId(String maternalProfileId) async {
  final response = await _supabase
      .from('child_profiles')
      .select()
      .eq('maternal_profile_id', maternalProfileId)
      .eq('is_active', true) // ✅ Filters active children
      .order('date_of_birth', ascending: false);
  // ...
}
```
**Status:** ✅ Working correctly after fix

---

## Testing Checklist

- [ ] Run `fix_patient_view_children.sql` in Supabase SQL Editor
- [ ] Verify RLS policies are created (check Supabase dashboard)
- [ ] Add a test child as a health worker
- [ ] Verify the child appears in the patient app
- [ ] Test with multiple mothers to ensure no cross-visibility
- [ ] Test that inactive children (`is_active = FALSE`) don't appear

---

## Common Issues & Solutions

### Issue: Children still not appearing

**Diagnosis Steps:**
1. Check if the maternal_profile_id is correct:
```sql
SELECT child_name, maternal_profile_id, is_active 
FROM child_profiles 
WHERE child_name = '<test child name>';
```

2. Check if the mother's auth_id matches:
```sql
SELECT mp.id, mp.client_name, mp.auth_id
FROM maternal_profiles mp
WHERE mp.client_name LIKE '%<mother name>%';
```

3. Verify the link:
```sql
SELECT * FROM public.debug_child_visibility('<child_id>');
```

### Issue: Health worker can't add children

**Check:**
- Does the health worker have a `user_profile` with `role = 'health_worker'`?
- Does the health worker's `facility_id` match the mother's `facility_id`?

```sql
SELECT up.id, up.role, up.facility_id, mp.facility_id as mother_facility
FROM user_profiles up
CROSS JOIN maternal_profiles mp
WHERE up.id = '<health_worker_auth_id>'
AND mp.id = '<maternal_profile_id>';
```

---

## Additional Improvements (Optional)

### 1. Add Real-time Subscription
Update the patient app to listen for new children:
```dart
// In child_provider.dart
ref.listen(currentMaternalProfileProvider, (previous, next) {
  // Refresh children when maternal profile changes
  ref.invalidate(patientChildrenProvider);
});
```

### 2. Add Notification When Child is Added
Create a database trigger to notify the mother:
```sql
CREATE OR REPLACE FUNCTION notify_patient_child_added()
RETURNS TRIGGER AS $$
DECLARE
  v_mother_auth_id UUID;
  v_mother_name TEXT;
BEGIN
  -- Get mother's auth_id
  SELECT mp.auth_id, mp.client_name INTO v_mother_auth_id, v_mother_name
  FROM maternal_profiles mp
  WHERE mp.id = NEW.maternal_profile_id;
  
  IF v_mother_auth_id IS NOT NULL THEN
    INSERT INTO notifications (user_id, title, body, type)
    VALUES (
      v_mother_auth_id,
      'Child Profile Created',
      'A profile has been created for ' || NEW.child_name,
      'child_registered'
    );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_child_profile_created
AFTER INSERT ON child_profiles
FOR EACH ROW
EXECUTE FUNCTION notify_patient_child_added();
```

---

## Success Criteria

✅ **Fix is successful when:**
1. Health worker can add a child for any mother in their facility
2. The child immediately appears in the mother's patient app (after refresh)
3. Children don't appear for other mothers
4. The child details screen opens correctly
5. Vaccination and growth tracking work for the child

---

## Summary

The issue was likely caused by missing or incorrect RLS policies and potentially NULL `is_active` values. The fix ensures:
- RLS policies are correctly configured
- `is_active` column exists and defaults to TRUE
- Debug tools are available to troubleshoot future issues

**Next Step:** Run the SQL script and test!
