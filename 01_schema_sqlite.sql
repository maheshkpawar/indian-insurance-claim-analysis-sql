-- ============================================================
-- INDIAN INSURANCE CLAIM ANALYSIS - DATABASE SCHEMA
-- Simulates a multi-line insurer (Health / Motor / Life / Term / Travel)
-- operating across major Indian cities, regulated under IRDAI norms.
-- ============================================================

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS hospitals;
DROP TABLE IF EXISTS agents;
DROP TABLE IF EXISTS customers;

-- ------------------------------------------------------------
-- CUSTOMERS (policyholders)
-- ------------------------------------------------------------
CREATE TABLE customers (
    customer_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name       TEXT NOT NULL,
    gender          TEXT CHECK (gender IN ('M','F','Other')),
    dob             DATE,
    city            TEXT,
    state           TEXT,
    pincode         TEXT,
    phone           TEXT,
    email           TEXT,
    occupation      TEXT,
    annual_income   INTEGER            -- in INR
);

-- ------------------------------------------------------------
-- AGENTS (IRDAI-licensed insurance agents / POSPs)
-- ------------------------------------------------------------
CREATE TABLE agents (
    agent_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    agent_name      TEXT NOT NULL,
    branch_city     TEXT,
    branch_state    TEXT,
    irdai_license   TEXT,
    joining_date    DATE
);

-- ------------------------------------------------------------
-- HOSPITALS (for health insurance network / cashless claims)
-- ------------------------------------------------------------
CREATE TABLE hospitals (
    hospital_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    hospital_name   TEXT NOT NULL,
    city            TEXT,
    state           TEXT,
    network_type    TEXT CHECK (network_type IN ('Cashless','Reimbursement Only'))
);

-- ------------------------------------------------------------
-- POLICIES
-- ------------------------------------------------------------
CREATE TABLE policies (
    policy_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id     INTEGER NOT NULL,
    agent_id        INTEGER,
    policy_type     TEXT CHECK (policy_type IN ('Health','Motor','Life','Term','Travel')),
    policy_name     TEXT,
    sum_insured     INTEGER,           -- in INR
    premium_amount  INTEGER,           -- in INR, annual
    start_date      DATE,
    end_date        DATE,
    status          TEXT CHECK (status IN ('Active','Lapsed','Cancelled','Matured')),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- ------------------------------------------------------------
-- CLAIMS
-- ------------------------------------------------------------
CREATE TABLE claims (
    claim_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id         INTEGER NOT NULL,
    hospital_id       INTEGER,          -- NULL for non-health claims
    claim_date        DATE,
    claim_type        TEXT,             -- e.g. Hospitalization, Accident, Own Damage, Theft, Death, Trip Cancellation
    claim_amount      INTEGER,          -- amount claimed, in INR
    approved_amount   INTEGER,          -- amount approved, in INR
    claim_status      TEXT CHECK (claim_status IN ('Approved','Rejected','Pending','Under Review')),
    settlement_mode   TEXT CHECK (settlement_mode IN ('Cashless','Reimbursement', NULL)),
    rejection_reason  TEXT,
    intimation_date   DATE,             -- date claim was first reported
    settlement_date   DATE,             -- date claim was closed (NULL if pending)
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id),
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

-- ------------------------------------------------------------
-- PAYMENTS (premium payment history)
-- ------------------------------------------------------------
CREATE TABLE payments (
    payment_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    policy_id       INTEGER NOT NULL,
    payment_date    DATE,
    amount          INTEGER,           -- in INR
    payment_mode    TEXT CHECK (payment_mode IN ('UPI','Net Banking','Credit Card','Debit Card','Cheque','Auto-Debit')),
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id)
);

-- ------------------------------------------------------------
-- Helpful indexes for analysis queries
-- ------------------------------------------------------------
CREATE INDEX idx_policies_customer ON policies(customer_id);
CREATE INDEX idx_policies_agent ON policies(agent_id);
CREATE INDEX idx_claims_policy ON claims(policy_id);
CREATE INDEX idx_claims_hospital ON claims(hospital_id);
CREATE INDEX idx_payments_policy ON payments(policy_id);
