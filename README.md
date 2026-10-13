# Clarity

**Medication Safety, Thoughtfully.** Less noise. More clarity.

Clarity is a drug interaction risk analyzer built for the *Life Sciences Drug Interaction Risk Analyzer* problem statement. It helps pharmacists and clinicians cut alert fatigue by ranking interaction alerts using patient context, recording how each alert is handled, and measuring the results.

> **Prototype notice.** Clarity is not a validated clinical decision-support system. Its scoring is a keyword-based heuristic, and the built-in interaction rules are illustrative samples. Use fictional data only. Do not use it for real patient care.

## The problem it addresses

| Challenge | How Clarity responds |
| --- | --- |
| High volume of alerts causes fatigue | Findings are ranked by patient-specific priority. Critical and High alerts lead, and lower ones collapse. |
| Raw interaction data lacks patient context | Age, conditions and allergies raise or lower each finding's priority and explain why. |
| Manual interpretation of complex interactions | Each report opens with a plain-language, patient-specific risk summary. |
| Poor integration with pharmacy and clinical workflows | Medications can be imported from an EHR through FHIR. |

## Features

- **Patient records** with age, conditions, allergies and medication lists, saved per account in Supabase.
- **Interaction analysis** with severity labels, evidence provenance and a coverage view showing which drug pairs were checked.
- **Patient-specific priority** that adjusts for age 65+, conditions (GI bleeding, renal, liver, QT, heart failure) and allergy matches.
- **Acknowledge or override** each alert. Overrides require a reason.
- **Risk summary and report** with a print option.
- **FDA label check** that pulls interaction text from the openFDA drug label API for a finding.
- **EHR import** from a pasted FHIR Bundle, or from a FHIR server, with an optional bearer token.
- **Audit log** with CSV export. In Supabase the hash chain is computed by the database, and edits and deletes are blocked.
- **Pilot metrics** computed from saved records, with baselines you set.

## Success metrics

| Target | How it is measured |
| --- | --- |
| Reduce critical alert overrides by 30% | Overridden critical alerts divided by critical alerts shown, compared with your baseline |
| Improve clinician satisfaction by 40% | Share of report ratings that are 4 or 5 out of 5, compared with your baseline |
| 90% accuracy in risk summaries | Clinicians mark each summary as accurate or not |
| Decrease adverse drug event rates | Entered manually from pilot data |

## Pages

Overview, Patients, Medications, Interactions, Reports, Data sources and Audit log.

## Tech

- Single-page app in plain HTML, CSS and JavaScript (`index.html`)
- Supabase for authentication and a Postgres database with row-level security
- openFDA for label lookups, and FHIR for EHR import
- Optional import of a DDInter-derived knowledge base from the Data sources page

## Setup

1. **Create a Supabase project** and enable email authentication.
2. **Edit `supabase-config.js`** with your project URL and **anon (public) key**. Never put a `service_role` key in this repo.
3. **Run the SQL** in the Supabase SQL Editor, in this order:
   1. `supabase/patients-details-migration.sql`
   2. `supabase/clarity-full-migration.sql`
4. **Serve the folder.** For example, run `python -m http.server 8000` and open `http://localhost:8000`. For GitHub Pages, set the Pages source to the `main` branch.
5. **Allow your site URL** in Supabase under Authentication, then URL Configuration, by setting the Site URL and adding it to the Redirect URLs.
6. Sign in, add a fictional patient and run an analysis.

## Quick demo

1. Add a patient aged 70 with the condition "GI ulcer".
2. Add warfarin and aspirin, then run the analysis.
3. Watch the priority rise to Critical and see the reason shown.
4. Override the alert with a reason, then rate the report.
5. Check the Overview metrics and the Audit log.

## Limitations

- Scoring is heuristic and not clinically validated.
- Built-in rules are a small illustrative set. Import a knowledge base from Data sources for wider coverage.
- DrugBank is not connected. It needs a paid key and a backend proxy.
- FHIR bearer tokens are typed in the browser. Use a backend proxy with real EHR systems.
- There is no role system. Everyone who signs in has the same access to their own records.
- HIPAA compliance requires hosting, policy and security controls beyond this code.
- Not yet tested end to end against a live Supabase project.

## Project files

- `index.html` is the app
- `supabase-config.js` holds the Supabase URL and anon key
- `supabase/` contains the database migrations
- `README.txt` holds the original setup notes
