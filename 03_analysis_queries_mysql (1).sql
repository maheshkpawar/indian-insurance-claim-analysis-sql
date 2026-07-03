USE insurance_claims;

-- ============================================================
-- ANALYSIS QUERIES: Indian Insurance Claim Analysis Project
-- ============================================================

-- 1. CLAIM SETTLEMENT RATIO by policy type
--    (Industry KPI: % of claims approved vs total claims filed)
SELECT
    p.policy_type,
    COUNT(c.claim_id) AS total_claims,
    SUM(CASE WHEN c.claim_status = 'Approved' THEN 1 ELSE 0 END) AS approved_claims,
    SUM(CASE WHEN c.claim_status = 'Rejected' THEN 1 ELSE 0 END) AS rejected_claims,
    ROUND(100.0 * SUM(CASE WHEN c.claim_status = 'Approved' THEN 1 ELSE 0 END) / COUNT(c.claim_id), 2) AS settlement_ratio_pct
FROM claims c
JOIN policies p ON p.policy_id = c.policy_id
GROUP BY p.policy_type
ORDER BY settlement_ratio_pct DESC;


-- 2. INCURRED CLAIM RATIO (ICR) by policy type
--    ICR = Total claims paid / Total premium collected. >100% means losses.
SELECT
    p.policy_type,
    SUM(pay.amount) AS total_premium_collected,
    COALESCE(SUM(c.approved_amount), 0) AS total_claims_paid,
    ROUND(100.0 * COALESCE(SUM(c.approved_amount), 0) / SUM(pay.amount), 2) AS incurred_claim_ratio_pct
FROM policies p
LEFT JOIN payments pay ON pay.policy_id = p.policy_id
LEFT JOIN claims c ON c.policy_id = p.policy_id AND c.claim_status = 'Approved'
GROUP BY p.policy_type
ORDER BY incurred_claim_ratio_pct DESC;


-- 3. CITY-WISE CLAIM ANALYSIS (customer's home city)
SELECT
    cu.city,
    cu.state,
    COUNT(c.claim_id) AS total_claims,
    SUM(c.claim_amount) AS total_claimed_amount,
    SUM(c.approved_amount) AS total_approved_amount,
    ROUND(AVG(c.claim_amount), 0) AS avg_claim_amount
FROM claims c
JOIN policies p ON p.policy_id = c.policy_id
JOIN customers cu ON cu.customer_id = p.customer_id
GROUP BY cu.city, cu.state
ORDER BY total_claimed_amount DESC;


-- 4. TOP HOSPITALS BY CLAIM VOLUME AND VALUE (cashless network analysis)
SELECT
    h.hospital_name,
    h.city,
    h.network_type,
    COUNT(c.claim_id) AS claim_count,
    SUM(c.approved_amount) AS total_approved_amount,
    ROUND(AVG(c.approved_amount), 0) AS avg_approved_amount
FROM claims c
JOIN hospitals h ON h.hospital_id = c.hospital_id
WHERE c.claim_status = 'Approved'
GROUP BY h.hospital_id
ORDER BY total_approved_amount DESC;


-- 5. REJECTION REASON BREAKDOWN
SELECT
    rejection_reason,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_rejected_value
FROM claims
WHERE claim_status = 'Rejected'
GROUP BY rejection_reason
ORDER BY num_claims DESC;


-- 6. CLAIM SETTLEMENT TURNAROUND TIME (TAT), in days -- a key IRDAI reporting metric
SELECT
    p.policy_type,
    ROUND(AVG(DATEDIFF(c.settlement_date, c.intimation_date)), 1) AS avg_days_to_settle,
    MIN(DATEDIFF(c.settlement_date, c.intimation_date)) AS fastest_settlement_days,
    MAX(DATEDIFF(c.settlement_date, c.intimation_date)) AS slowest_settlement_days
FROM claims c
JOIN policies p ON p.policy_id = c.policy_id
WHERE c.settlement_date IS NOT NULL
GROUP BY p.policy_type
ORDER BY avg_days_to_settle DESC;


-- 7. MONTHLY CLAIM TREND (for identifying seasonality, e.g. monsoon-related health/motor spikes)
SELECT
    DATE_FORMAT(claim_date, '%Y-%m') AS claim_month,
    COUNT(*) AS num_claims,
    SUM(claim_amount) AS total_claim_value
FROM claims
GROUP BY claim_month
ORDER BY claim_month;


-- 8. AGENT PERFORMANCE: policies sold, premium generated, and linked claims ratio
SELECT
    a.agent_name,
    a.branch_city,
    COUNT(DISTINCT p.policy_id) AS policies_sold,
    SUM(p.premium_amount) AS total_premium_booked,
    COUNT(c.claim_id) AS claims_on_book,
    ROUND(100.0 * SUM(CASE WHEN c.claim_status = 'Rejected' THEN 1 ELSE 0 END) / NULLIF(COUNT(c.claim_id), 0), 2) AS rejection_rate_pct
FROM agents a
JOIN policies p ON p.agent_id = a.agent_id
LEFT JOIN claims c ON c.policy_id = p.policy_id
GROUP BY a.agent_id
ORDER BY total_premium_booked DESC;


-- 9. HIGH-RISK / REPEAT CLAIMANTS (customers with 2+ claims -- useful for underwriting review)
SELECT
    cu.full_name,
    cu.city,
    COUNT(c.claim_id) AS num_claims,
    SUM(c.claim_amount) AS total_claimed,
    SUM(c.approved_amount) AS total_approved
FROM claims c
JOIN policies p ON p.policy_id = c.policy_id
JOIN customers cu ON cu.customer_id = p.customer_id
GROUP BY cu.customer_id
HAVING COUNT(c.claim_id) >= 2
ORDER BY num_claims DESC, total_claimed DESC;


-- 10. POTENTIAL FRAUD / ANOMALY FLAGS
--     Rule-based flags: claim amount very close to (or exceeding) sum insured,
--     or multiple claims filed on the same policy within 90 days.
SELECT
    c.claim_id,
    p.policy_id,
    cu.full_name,
    p.policy_type,
    p.sum_insured,
    c.claim_amount,
    ROUND(100.0 * c.claim_amount / p.sum_insured, 1) AS pct_of_sum_insured,
    c.claim_status
FROM claims c
JOIN policies p ON p.policy_id = c.policy_id
JOIN customers cu ON cu.customer_id = p.customer_id
WHERE c.claim_amount >= 0.25 * p.sum_insured
ORDER BY pct_of_sum_insured DESC;


-- 11. CASHLESS vs REIMBURSEMENT MIX (health claims only)
SELECT
    settlement_mode,
    COUNT(*) AS num_claims,
    SUM(approved_amount) AS total_paid,
    ROUND(AVG(DATEDIFF(settlement_date, intimation_date)), 1) AS avg_tat_days
FROM claims
WHERE settlement_mode IS NOT NULL
GROUP BY settlement_mode;


-- 12. POLICY LAPSE / RENEWAL RISK: active policies nearing expiry (within 60 days of a reference date)
--     Replace '2025-07-02' with CURRENT_DATE in production.
SELECT
    p.policy_id,
    cu.full_name,
    p.policy_type,
    p.end_date,
    DATEDIFF(p.end_date, '2025-07-02') AS days_to_expiry
FROM policies p
JOIN customers cu ON cu.customer_id = p.customer_id
WHERE p.status = 'Active'
  AND DATEDIFF(p.end_date, '2025-07-02') BETWEEN 0 AND 60
ORDER BY days_to_expiry;


-- 13. AGE-BAND WISE HEALTH CLAIM ANALYSIS (common actuarial cut for pricing)
SELECT
    CASE
        WHEN (2025 - YEAR(cu.dob)) < 30 THEN '18-29'
        WHEN (2025 - YEAR(cu.dob)) < 45 THEN '30-44'
        WHEN (2025 - YEAR(cu.dob)) < 60 THEN '45-59'
        ELSE '60+'
    END AS age_band,
    COUNT(c.claim_id) AS num_claims,
    ROUND(AVG(c.claim_amount), 0) AS avg_claim_amount
FROM claims c
JOIN policies p ON p.policy_id = c.policy_id AND p.policy_type = 'Health'
JOIN customers cu ON cu.customer_id = p.customer_id
GROUP BY age_band
ORDER BY age_band;


-- 14. STATE-WISE PREMIUM vs CLAIMS SUMMARY (business performance by region)
--     Premiums and claims are aggregated in separate subqueries first to avoid
--     fan-out duplication from the one-to-many policy->claims join.
SELECT
    cu.state,
    SUM(prem.total_policies) AS total_policies,
    SUM(prem.total_premium) AS total_premium,
    COALESCE(SUM(clm.total_claims_paid), 0) AS total_claims_paid
FROM customers cu
JOIN (
    SELECT customer_id, COUNT(*) AS total_policies, SUM(premium_amount) AS total_premium
    FROM policies
    GROUP BY customer_id
) prem ON prem.customer_id = cu.customer_id
LEFT JOIN (
    SELECT p.customer_id, SUM(c.approved_amount) AS total_claims_paid
    FROM claims c
    JOIN policies p ON p.policy_id = c.policy_id
    WHERE c.claim_status = 'Approved'
    GROUP BY p.customer_id
) clm ON clm.customer_id = cu.customer_id
GROUP BY cu.state
ORDER BY total_premium DESC;


-- 15. TOP 5 CUSTOMERS BY LIFETIME PREMIUM PAID
SELECT
    cu.full_name,
    cu.city,
    SUM(pay.amount) AS lifetime_premium_paid
FROM payments pay
JOIN policies p ON p.policy_id = pay.policy_id
JOIN customers cu ON cu.customer_id = p.customer_id
GROUP BY cu.customer_id
ORDER BY lifetime_premium_paid DESC
LIMIT 5;
