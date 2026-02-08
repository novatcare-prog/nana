## ✅ FIX READY: Children Visibility Issue

**Status:** SQL script corrected and ready to run!

### What Was Fixed
The SQL script had an error - it was trying to use `mp.full_name` but the actual column in the `maternal_profiles` table is `mp.client_name`.

**Fixed issues:**
- ✅ Changed `mp.full_name` to `mp.client_name` (2 locations)
- ✅ Removed non-existent `is_active` column check for maternal_profiles
- ✅ Updated documentation to match

### 🚀 Next Steps

**1. Run the SQL Script**
Open Supabase SQL Editor and run:
```
database/fix_patient_view_children.sql
```

**2. Expected Result**
You should see:
- ✅ Column `is_active` added (if it didn't exist)
- ✅ RLS policies recreated
- ✅ Debug function created
- ✅ Helper view created
- ✅ No errors!

**3. Test It**
After running the script:

a) **As Health Worker:**
   - Open the health worker app
   - Go to a patient profile
   - Click "Add Child"
   - Fill in the details and save
   
b) **As Patient (Mother):**
   - Open the patient app
   - Log in as that mother
   - Go to "My Children" section
   - **The child should now appear!** 🎉

### 🔍 Debug Tools (if needed)

If children still don't appear, run these queries in Supabase:

**Check a specific child:**
```sql
SELECT * FROM public.debug_child_visibility('<paste-child-id-here>');
```

**View all children and their links:**
```sql
SELECT * FROM public.v_child_parent_link LIMIT 20;
```

**Count children per mother:**
```sql
SELECT maternal_profile_id, COUNT(*) as child_count
FROM child_profiles 
WHERE is_active = TRUE
GROUP BY maternal_profile_id
ORDER BY child_count DESC;
```

### 📝 What This Fix Does

1. **Ensures `is_active` column exists** - So children aren't accidentally hidden
2. **Recreates RLS policies** - Allows parents to see their children
3. **Verifies health worker policies** - Allows health workers to add children
4. **Adds debug tools** - Helps troubleshoot future issues

### ⚠️ Important Notes

- The child must have `is_active = TRUE` to appear
- The child must have the correct `maternal_profile_id` 
- The mother must be logged in with the same `auth_id` linked to her maternal profile
- If using multiple maternal profiles per user, all profiles are checked

### 📚 Full Documentation

For complete details, see: `.review/children_visibility_fix.md`

---

**Ready to run!** Copy and paste the SQL script into Supabase SQL Editor now. 🚀
