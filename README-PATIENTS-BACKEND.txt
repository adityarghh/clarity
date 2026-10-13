CLARITY v0.19 — PATIENTS BACKEND STEP

This package starts connecting the existing Patients page to the existing Supabase patients table.

BEFORE TESTING
1. In Supabase SQL Editor, run supabase/patients-details-migration.sql once.
2. Keep the existing supabase-config.js values (Project URL + publishable key).
3. Serve this folder over HTTP with Live Server (not file://).
4. Sign in, open Patients, and add/edit/archive a fictional patient.
5. Refresh the page and confirm the record remains. Use a second test account to verify it cannot see the first account's records.

WHAT CHANGED
- Patient records are loaded from the signed-in user's Supabase `patients` table.
- New/updated/archive state is written to Supabase using the current authenticated user and existing RLS.
- The legacy patient localStorage list is no longer loaded, to avoid showing one account's browser-local data to another account.
- Additional v0.19 patient fields are stored in `patients.details` JSONB; normalized name, date of birth, archive timestamp and database patient code remain in their own columns.

LIMITS
- This step connects patient records only. Assessment history, audit log and medication findings still need separate persistence integration.
- The browser-side prototype is not clinically validated. Use fictional data only. Do not treat this as production-ready for identifiable health information.
- If your database schema differs from the schema we previously prepared, the migration/query may fail; share the exact Supabase error rather than changing RLS policies blindly.
