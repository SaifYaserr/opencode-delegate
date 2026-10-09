Load skills delegate-core and {{project_skill}}. PLAN ONLY: do not edit any file.
Ticket: {{ticket}}. Scope of this run: {{scope}}.

Find the code with graphify and targeted reads (at most ~12 files). Then reply with, and nothing else:
1. Files to create/change, one line each with what changes.
2. Existing code to copy (path + function) for each new piece.
3. Data/SQL changes, with the access rules (who can read/write).
4. Tests to add.
5. Open questions or anything risky (auth, access rules, secrets, personal data).
Keep it under 60 lines.
Rules for the plan: new migrations are dated today (YYYYMMDD of today, then a 6-digit sequence after the latest file of today); prefer a well-known npm package over hand-written crypto, parsing or protocols, and name it.
