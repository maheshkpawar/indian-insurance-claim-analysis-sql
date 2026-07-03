-- ============================================================
-- INDIAN INSURANCE CLAIM ANALYSIS - DATABASE SCHEMA (MySQL version)
-- Simulates a multi-line insurer (Health / Motor / Life / Term / Travel)
-- operating across major Indian cities, regulated under IRDAI norms.
-- ============================================================

CREATE DATABASE IF NOT EXISTS insurance_claims;
USE insurance_claims;

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
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    full_name       VARCHAR(100) NOT NULL,
    gender          ENUM('M','F','Other'),
    dob             DATE,
    city            VARCHAR(50),
    state           VARCHAR(50),
    pincode         VARCHAR(10),
    phone           VARCHAR(15),
    email           VARCHAR(100),
    occupation      VARCHAR(50),
    annual_income   INT            -- in INR
);

-- ------------------------------------------------------------
-- AGENTS (IRDAI-licensed insurance agents / POSPs)
-- ------------------------------------------------------------
CREATE TABLE agents (
    agent_id        INT AUTO_INCREMENT PRIMARY KEY,
    agent_name      VARCHAR(100) NOT NULL,
    branch_city     VARCHAR(50),
    branch_state    VARCHAR(50),
    irdai_license   VARCHAR(20),
    joining_date    DATE
);

-- ------------------------------------------------------------
-- HOSPITALS (for health insurance network / cashless claims)
-- ------------------------------------------------------------
CREATE TABLE hospitals (
    hospital_id     INT AUTO_INCREMENT PRIMARY KEY,
    hospital_name   VARCHAR(100) NOT NULL,
    city            VARCHAR(50),
    state           VARCHAR(50),
    network_type    ENUM('Cashless','Reimbursement Only')
);

-- ------------------------------------------------------------
-- POLICIES
-- ------------------------------------------------------------
CREATE TABLE policies (
    policy_id       INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    agent_id        INT,
    policy_type     ENUM('Health','Motor','Life','Term','Travel'),
    policy_name     VARCHAR(100),
    sum_insured     INT,           -- in INR
    premium_amount  INT,           -- in INR, annual
    start_date      DATE,
    end_date        DATE,
    status          ENUM('Active','Lapsed','Cancelled','Matured'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- ------------------------------------------------------------
-- CLAIMS
-- ------------------------------------------------------------
CREATE TABLE claims (
    claim_id          INT AUTO_INCREMENT PRIMARY KEY,
    policy_id         INT NOT NULL,
    hospital_id       INT,          -- NULL for non-health claims
    claim_date        DATE,
    claim_type        VARCHAR(50),  -- e.g. Hospitalization, Accident, Own Damage, Theft, Death, Trip Cancellation
    claim_amount      INT,          -- amount claimed, in INR
    approved_amount   INT,          -- amount approved, in INR
    claim_status      ENUM('Approved','Rejected','Pending','Under Review'),
    settlement_mode   ENUM('Cashless','Reimbursement'),
    rejection_reason  VARCHAR(100),
    intimation_date   DATE,         -- date claim was first reported
    settlement_date   DATE,         -- date claim was closed (NULL if pending)
    FOREIGN KEY (policy_id) REFERENCES policies(policy_id),
    FOREIGN KEY (hospital_id) REFERENCES hospitals(hospital_id)
);

-- ------------------------------------------------------------
-- PAYMENTS (premium payment history)
-- ------------------------------------------------------------
CREATE TABLE payments (
    payment_id      INT AUTO_INCREMENT PRIMARY KEY,
    policy_id       INT NOT NULL,
    payment_date    DATE,
    amount          INT,           -- in INR
    payment_mode    ENUM('UPI','Net Banking','Credit Card','Debit Card','Cheque','Auto-Debit'),
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
