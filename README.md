# SmartBill — Receipt & Expense Manager

Upload a receipt → OCR extracts store / date / amount / tax / items → auto-categorized → saved to Supabase. Insights tab shows monthly spend by category and flags unusual spending vs your 3-month average.

Stack: single `index.html` (no build) + Supabase (DB + Auth) + Tesseract.js (OCR, runs in browser).

## Setup (5 min)
1. Create a project at [supabase.com](https://supabase.com).
2. **SQL Editor** → paste `schema.sql` → Run (creates `expenses` table + row-level security).
3. **Project Settings → API** → copy the Project URL and `anon` public key into `config.js`.
4. **Authentication → Providers**: enable the ones you want:
   - **Email** — on by default.
   - **Google** — add OAuth client ID/secret (Google Cloud Console), set redirect to the value Supabase shows.
   - **Phone** — enable and connect an SMS provider (Twilio/MessageBird).
5. **Authentication → URL Configuration** → add your site URL (e.g. `http://localhost:5500`) to redirect allow-list.

## Run
Serve the folder over http (OAuth/OCR need a real origin, not `file://`):
```bash
python -m http.server 5500
```
Open http://localhost:5500

## Notes
- The anon key is safe in the client; all data access is protected by RLS (users only see their own rows).
- OCR runs fully client-side — receipts are never uploaded to a third party. Always review extracted fields before saving.
- Unusual-spending rule: current-month category total > 1.2× the average monthly spend for that category over the prior 3 months.
