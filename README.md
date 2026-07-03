# Indian Insurance Claim Analysis — SQL Project

A self-contained SQL project simulating claims operations for a multi-line
Indian insurer (Health, Motor, Life, Term, Travel), built for portfolio /
practice use. Written in SQLite-compatible SQL (runs with only minor tweaks
in MySQL / PostgreSQL — see **Notes on portability** below).

## Files

| File | Purpose |
|---|---|
| `01_schema_sqlite.sql` | Creates 6 tables: `customers`, `agents`, `hospitals`, `policies`, `claims`, `payments`, plus indexes. (SQLite dialect) |
| `02_sample_data_sqlite.sql` | Realistic Indian sample data — 15 customers, 8 agents, 8 hospitals, 25 policies, 30 claims, 31 premium payments across cities like Mumbai, Bangalore, Delhi, Chennai, Kolkata, etc. |
| `03_analysis_queries_sqlite.sql` | 15 business-analysis queries (see below). |
| `mysql/01_schema_mysql.sql` | Same schema, MySQL dialect — run this in MySQL Workbench. |
| `mysql/02_sample_data_mysql.sql` | Same sample data, MySQL dialect. |
| `mysql/03_analysis_queries_mysql.sql` | Same 15 queries, MySQL dialect (uses `DATEDIFF`, `DATE_FORMAT`, `YEAR`). |

## Schema overview

```
customers (1) ───< policies (M) ───< claims (M) >─── hospitals (1)
                        │
                        └───< payments (M)

agents (1) ───< policies (M)
```

- **customers** — policyholder demographics (city, state, income, occupation).
- **agents** — IRDAI-licensed agents who sold each policy.
- **hospitals** — network hospitals for cashless health claims.
- **policies** — one row per policy; `policy_type` in Health/Motor/Life/Term/Travel.
- **claims** — one row per claim event, with status, settlement mode, TAT dates, and rejection reason.
- **payments** — premium payment history per policy.

## Included analyses (`03_analysis_queries.sql`)

1. Claim settlement ratio by policy type
2. Incurred Claim Ratio (ICR) — claims paid vs premium collected
3. City-wise claim volume and value
4. Top network hospitals by claim value (cashless analysis)
5. Rejection reason breakdown
6. Claim settlement turnaround time (TAT) by policy type
7. Monthly claim trend (seasonality)
8. Agent performance — book size, premium, rejection rate
9. High-risk / repeat claimants
10. Rule-based fraud/anomaly flags (claim amount vs sum insured)
11. Cashless vs reimbursement mix
12. Policies nearing expiry (renewal risk)
13. Age-band-wise health claim analysis
14. State-wise premium vs claims summary
15. Top 5 customers by lifetime premium paid

## How to run

**SQLite (simplest — no server needed):**
```bash
sqlite3 insurance.db < 01_schema_sqlite.sql
sqlite3 insurance.db < 02_sample_data_sqlite.sql
sqlite3 insurance.db < 03_analysis_queries_sqlite.sql
```
Or open `insurance.db` in DB Browser for SQLite and run queries interactively.

**MySQL Workbench:**
1. Open `mysql/01_schema_mysql.sql` → run (creates the `insurance_claims` database + tables)
2. Open `mysql/02_sample_data_mysql.sql` → run (loads sample data)
3. Open `mysql/03_analysis_queries_mysql.sql` → run queries one at a time (select a query, then `Ctrl+Enter`)

**Python (no install needed beyond stdlib):**
```python
import sqlite3
conn = sqlite3.connect("insurance.db")
conn.executescript(open("01_schema_sqlite.sql").read())
conn.executescript(open("02_sample_data_sqlite.sql").read())
print(conn.execute(open("03_analysis_queries_sqlite.sql").read().split(";")[0]).fetchall())
```

## Notes on portability (MySQL / PostgreSQL)

This project uses SQLite syntax in three places that differ across engines:

- `AUTOINCREMENT` → MySQL: `AUTO_INCREMENT`; PostgreSQL: `SERIAL` / `GENERATED ALWAYS AS IDENTITY`.
- `julianday(date2) - julianday(date1)` (day difference) → MySQL: `DATEDIFF(date2, date1)`; PostgreSQL: `date2 - date1`.
- `strftime('%Y-%m', col)` (date formatting) → MySQL: `DATE_FORMAT(col, '%Y-%m')`; PostgreSQL: `TO_CHAR(col, 'YYYY-MM')`.

Everything else (JOINs, GROUP BY, subqueries, CASE, window-style aggregates) is
standard ANSI SQL and needs no changes.

## Ideas to extend this project

- Add a `window function` version of query 9 using `RANK()` per city.
- Add a `fraud_score` view combining rule #10 with claim-frequency anomalies.
- Bring in GST on premiums (18% for most general insurance in India) as a computed column.
- Add a `reinsurance` table to model risk ceded above a retention limit.
- Load this into a BI tool (Power BI / Metabase) for dashboarding on top of the same schema.
