CLARITY v0.19 — AUTHENTICATION THEN THE FINAL DASHBOARD

This package uses the uploaded clarity-standalone v0.19 as the dashboard that appears after Supabase authentication. It preserves the finalized dashboard UI and its existing client-side workflow code.

Setup:
1. Configure supabase-config.js with your existing Supabase project URL and publishable key.
2. Serve this folder over HTTP (VS Code Live Server or `npx serve .`); do not open index.html as a file.
3. Sign in or create an account. The dashboard is shown only after a valid Supabase session is present.
4. The account email and Sign out control are available by clicking the top-right CR avatar.

Important:
- This connects the auth gate to the v0.19 dashboard; it does not automatically migrate legacy localStorage patient/assessment data into Supabase tables.
- The v0.19 dashboard's existing data workflows remain client-side until separately integrated with database operations and verified RLS. Use fictional data only until then.
- Never use a Supabase service_role/secret key in browser code.

--- FULL REQUIREMENTS UPDATE ---
New file: supabase/clarity-full-migration.sql (run once in Supabase SQL Editor after patients-details-migration.sql).
Added: patient-specific alert priority with collapsed lower-priority findings; acknowledge/override with required reason; audit log whose hash chain and append-only rule are enforced by database triggers (Supabase audit_log, CSV export, Clear button removed); no role selector; assessments, alert decisions and feedback saved to Supabase; pilot metrics computed from saved Supabase records (browser-only fallback when signed out) with baselines; FHIR import (paste or server fetch); per-finding openFDA label check.
Fixed: patient saves referenced a Supabase client that was out of scope; it is now shared via window.__sb / window.__sess.
Limits: no role system (single clinician view); context scoring is a keyword heuristic, not a validated clinical model; DrugBank needs a paid key and a backend proxy (not connected); FHIR bearer tokens are typed in the browser, so use a backend proxy with real EHRs; adverse event figure is entered by hand; not end-to-end tested against a live Supabase project; fictional data only.
