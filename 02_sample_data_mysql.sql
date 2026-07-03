USE insurance_claims;

-- ============================================================
-- SAMPLE DATA: Indian Insurance Claim Analysis Project
-- ============================================================

-- ------------------------------------------------------------
-- CUSTOMERS
-- ------------------------------------------------------------
INSERT INTO customers (full_name, gender, dob, city, state, pincode, phone, email, occupation, annual_income) VALUES
('Rohan Sharma',        'M', '1985-04-12', 'Mumbai',    'Maharashtra',    '400001', '9821012345', 'rohan.sharma@example.com',   'Software Engineer', 1800000),
('Priya Iyer',          'F', '1990-08-23', 'Bangalore', 'Karnataka',      '560001', '9880123456', 'priya.iyer@example.com',     'Doctor',             2500000),
('Amit Verma',          'M', '1978-01-15', 'Delhi',     'Delhi',          '110001', '9871234567', 'amit.verma@example.com',     'Business Owner',     4200000),
('Sneha Reddy',         'F', '1995-11-02', 'Hyderabad', 'Telangana',      '500001', '9908765432', 'sneha.reddy@example.com',    'Marketing Manager',  1200000),
('Vikram Singh',        'M', '1982-06-30', 'Jaipur',    'Rajasthan',      '302001', '9829012345', 'vikram.singh@example.com',   'Farmer',             600000),
('Anjali Gupta',        'F', '1988-03-19', 'Lucknow',   'Uttar Pradesh',  '226001', '9415123456', 'anjali.gupta@example.com',   'Teacher',            700000),
('Karthik Nair',        'M', '1992-09-05', 'Chennai',   'Tamil Nadu',     '600001', '9840123456', 'karthik.nair@example.com',   'Bank Manager',       1500000),
('Meera Joshi',         'F', '1975-12-28', 'Pune',      'Maharashtra',    '411001', '9822012345', 'meera.joshi@example.com',    'Homemaker',          400000),
('Arjun Malhotra',      'M', '1998-02-14', 'Delhi',     'Delhi',          '110002', '9873456789', 'arjun.malhotra@example.com', 'Consultant',         1600000),
('Divya Krishnan',      'F', '1983-07-08', 'Chennai',   'Tamil Nadu',     '600002', '9843456789', 'divya.krishnan@example.com', 'Professor',          1100000),
('Rajesh Kumar',        'M', '1970-10-21', 'Kolkata',   'West Bengal',    '700001', '9830123456', 'rajesh.kumar@example.com',   'Retired Govt Officer',900000),
('Neha Agarwal',        'F', '1993-05-17', 'Ahmedabad', 'Gujarat',        '380001', '9825012345', 'neha.agarwal@example.com',   'CA',                  1900000),
('Suresh Pillai',       'M', '1980-03-03', 'Kochi',     'Kerala',         '682001', '9847012345', 'suresh.pillai@example.com',  'Merchant Navy',       2200000),
('Kavita Deshmukh',     'F', '1987-09-27', 'Mumbai',    'Maharashtra',    '400002', '9820123456', 'kavita.deshmukh@example.com','HR Manager',          1300000),
('Manoj Tiwari',        'M', '1965-01-09', 'Patna',     'Bihar',          '800001', '9934012345', 'manoj.tiwari@example.com',   'Shopkeeper',          500000);

-- ------------------------------------------------------------
-- AGENTS
-- ------------------------------------------------------------
INSERT INTO agents (agent_name, branch_city, branch_state, irdai_license, joining_date) VALUES
('Sanjay Mehta',    'Mumbai',    'Maharashtra',   'IRDAI-A1023', '2015-06-01'),
('Pooja Rao',       'Bangalore', 'Karnataka',     'IRDAI-A1045', '2017-03-15'),
('Deepak Chawla',   'Delhi',     'Delhi',         'IRDAI-A1067', '2014-11-20'),
('Lakshmi Menon',   'Chennai',   'Tamil Nadu',    'IRDAI-A1089', '2019-01-10'),
('Ravi Patel',      'Ahmedabad', 'Gujarat',       'IRDAI-A1102', '2016-07-25'),
('Nisha Bose',      'Kolkata',   'West Bengal',   'IRDAI-A1124', '2018-09-05'),
('Ajay Kulkarni',   'Pune',      'Maharashtra',   'IRDAI-A1146', '2020-02-14'),
('Farhan Sheikh',   'Hyderabad', 'Telangana',     'IRDAI-A1168', '2013-05-30');

-- ------------------------------------------------------------
-- HOSPITALS
-- ------------------------------------------------------------
INSERT INTO hospitals (hospital_name, city, state, network_type) VALUES
('Apollo Hospitals',            'Chennai',   'Tamil Nadu',    'Cashless'),
('Fortis Hospital',             'Mumbai',    'Maharashtra',   'Cashless'),
('Max Super Speciality',        'Delhi',     'Delhi',         'Cashless'),
('Manipal Hospital',            'Bangalore', 'Karnataka',     'Cashless'),
('Yashoda Hospitals',           'Hyderabad', 'Telangana',     'Cashless'),
('Ruby General Hospital',       'Kolkata',   'West Bengal',   'Reimbursement Only'),
('Sterling Hospital',           'Ahmedabad', 'Gujarat',       'Cashless'),
('Aster Medcity',               'Kochi',     'Kerala',        'Cashless');

-- ------------------------------------------------------------
-- POLICIES
-- ------------------------------------------------------------
INSERT INTO policies (customer_id, agent_id, policy_type, policy_name, sum_insured, premium_amount, start_date, end_date, status) VALUES
(1,  1, 'Health', 'HealthShield Gold',        1000000, 18500, '2023-04-01', '2026-03-31', 'Active'),
(1,  1, 'Motor',  'CarSecure Comprehensive',   800000, 22000, '2024-01-15', '2025-01-14', 'Lapsed'),
(2,  2, 'Health', 'HealthShield Platinum',    2000000, 32000, '2022-08-23', '2025-08-22', 'Active'),
(3,  3, 'Life',   'LifeGuard Term Plan',     10000000, 45000, '2020-01-15', '2040-01-14', 'Active'),
(3,  3, 'Motor',  'CarSecure Comprehensive',  1200000, 28000, '2024-06-01', '2025-05-31', 'Active'),
(4,  8, 'Health', 'HealthShield Silver',       500000, 9500,  '2023-11-02', '2026-11-01', 'Active'),
(5,  5, 'Motor',  'TractorSuraksha Plan',      600000, 12000, '2023-06-30', '2024-06-29', 'Lapsed'),
(6,  6, 'Term',   'SecureLife Term',          5000000, 15000, '2021-03-19', '2041-03-18', 'Active'),
(7,  4, 'Health', 'HealthShield Gold',        1000000, 17500, '2022-09-05', '2025-09-04', 'Active'),
(8,  7, 'Health', 'HealthShield Silver',       500000, 8800,  '2023-03-19', '2026-03-18', 'Active'),
(9,  3, 'Travel', 'TravelSafe International',  300000, 3500,  '2024-12-01', '2025-01-15', 'Matured'),
(9,  3, 'Motor',  'BikeSecure Plan',           150000, 4200,  '2024-02-14', '2025-02-13', 'Active'),
(10, 4, 'Health', 'HealthShield Platinum',    2000000, 31000, '2021-07-08', '2026-07-07', 'Active'),
(11, 6, 'Health', 'HealthShield Gold',        1000000, 19000, '2023-10-21', '2026-10-20', 'Active'),
(12, 5, 'Term',   'SecureLife Term',          7500000, 21000, '2022-05-17', '2042-05-16', 'Active'),
(12, 5, 'Motor',  'CarSecure Comprehensive',  1500000, 34000, '2024-03-01', '2025-02-28', 'Active'),
(13, 8, 'Health', 'HealthShield Platinum',    2000000, 33000, '2020-03-03', '2025-03-02', 'Active'),
(14, 1, 'Health', 'HealthShield Gold',        1000000, 18000, '2023-09-27', '2026-09-26', 'Active'),
(14, 1, 'Motor',  'CarSecure Comprehensive',   900000, 24000, '2024-08-01', '2025-07-31', 'Active'),
(15, 6, 'Health', 'HealthShield Silver',       500000, 9000,  '2022-01-09', '2025-01-08', 'Cancelled'),
(2,  2, 'Motor',  'CarSecure Comprehensive',  1100000, 26000, '2024-05-10', '2025-05-09', 'Active'),
(6,  6, 'Health', 'HealthShield Silver',       500000, 8700,  '2024-04-01', '2027-03-31', 'Active'),
(10, 4, 'Motor',  'CarSecure Comprehensive',   950000, 23000, '2024-07-15', '2025-07-14', 'Active'),
(13, 8, 'Term',   'SecureLife Term',          6000000, 17000, '2019-11-11', '2039-11-10', 'Active'),
(7,  4, 'Motor',  'BikeSecure Plan',           120000, 3800,  '2024-09-01', '2025-08-31', 'Active');

-- ------------------------------------------------------------
-- CLAIMS
-- ------------------------------------------------------------
INSERT INTO claims (policy_id, hospital_id, claim_date, claim_type, claim_amount, approved_amount, claim_status, settlement_mode, rejection_reason, intimation_date, settlement_date) VALUES
(1,  2, '2024-06-10', 'Hospitalization',    185000, 175000, 'Approved', 'Cashless',      NULL,                              '2024-06-10', '2024-06-18'),
(1,  2, '2025-01-22', 'Hospitalization',     45000,      0, 'Rejected', NULL,            'Pre-existing disease not covered','2025-01-22', '2025-02-05'),
(2,  NULL,'2024-05-03', 'Own Damage',         60000,  55000, 'Approved', 'Reimbursement', NULL,                              '2024-05-03', '2024-05-20'),
(3,  4, '2023-02-14', 'Hospitalization',    320000, 320000, 'Approved', 'Cashless',      NULL,                              '2023-02-14', '2023-02-22'),
(3,  4, '2024-11-01', 'Hospitalization',     28000,  28000, 'Approved', 'Cashless',      NULL,                              '2024-11-01', '2024-11-06'),
(5,  NULL,'2024-09-18', 'Own Damage',        150000, 140000, 'Approved', 'Reimbursement', NULL,                              '2024-09-18', '2024-10-02'),
(5,  NULL,'2025-02-10', 'Theft',             200000,      0, 'Pending',  NULL,            NULL,                              '2025-02-10', NULL),
(6,  5, '2024-03-25', 'Hospitalization',     78000,  70000, 'Approved', 'Cashless',      NULL,                              '2024-03-25', '2024-04-01'),
(7,  NULL,'2023-12-05', 'Own Damage',         90000,  80000, 'Approved', 'Reimbursement', NULL,                              '2023-12-05', '2023-12-20'),
(9,  1, '2023-01-10', 'Hospitalization',    150000, 150000, 'Approved', 'Cashless',      NULL,                              '2023-01-10', '2023-01-16'),
(9,  1, '2024-07-19', 'Hospitalization',     32000,      0, 'Rejected', NULL,            'Waiting period not completed',   '2024-07-19', '2024-08-01'),
(10, NULL,'2024-02-28', 'Hospitalization',     55000,  50000, 'Approved', 'Reimbursement', NULL,                            '2024-02-28', '2024-03-15'),
(11, NULL,'2025-01-05', 'Trip Cancellation',   20000,  18000, 'Approved', 'Reimbursement', NULL,                            '2025-01-05', '2025-01-12'),
(12, NULL,'2024-10-11', 'Theft',              45000,      0, 'Under Review', NULL,        NULL,                              '2024-10-11', NULL),
(13, 3, '2022-08-30', 'Hospitalization',    410000, 400000, 'Approved', 'Cashless',      NULL,                              '2022-08-30', '2022-09-08'),
(13, 3, '2024-04-14', 'Hospitalization',     95000,  95000, 'Approved', 'Cashless',      NULL,                              '2024-04-14', '2024-04-20'),
(14, 6, '2024-01-20', 'Hospitalization',    120000, 100000, 'Approved', 'Reimbursement', NULL,                              '2024-01-20', '2024-02-10'),
(16, NULL,'2024-12-02', 'Own Damage',        220000, 200000, 'Approved', 'Reimbursement', NULL,                              '2024-12-02', '2024-12-20'),
(17, 8, '2021-05-19', 'Hospitalization',    600000, 580000, 'Approved', 'Cashless',      NULL,                              '2021-05-19', '2021-05-28'),
(17, 8, '2023-09-02', 'Hospitalization',     18000,  18000, 'Approved', 'Cashless',      NULL,                              '2023-09-02', '2023-09-07'),
(17, 8, '2024-11-20', 'Hospitalization',     72000,      0, 'Rejected', NULL,            'Policy lapsed at time of claim',  '2024-11-20', '2024-12-01'),
(18, 2, '2024-06-28', 'Hospitalization',     65000,  60000, 'Approved', 'Cashless',      NULL,                              '2024-06-28', '2024-07-04'),
(19, NULL,'2025-01-15', 'Own Damage',         38000,  35000, 'Approved', 'Reimbursement', NULL,                              '2025-01-15', '2025-01-30'),
(21, NULL,'2024-08-09', 'Own Damage',         75000,  68000, 'Approved', 'Reimbursement', NULL,                              '2024-08-09', '2024-08-25'),
(22, 6, '2024-10-30', 'Hospitalization',     42000,  40000, 'Approved', 'Cashless',      NULL,                              '2024-10-30', '2024-11-04'),
(23, NULL,'2025-02-18', 'Own Damage',        130000,      0, 'Pending',  NULL,            NULL,                              '2025-02-18', NULL),
(9,  1, '2025-03-01', 'Hospitalization',     51000,  48000, 'Approved', 'Cashless',      NULL,                              '2025-03-01', '2025-03-09'),
(1,  2, '2025-04-15', 'Hospitalization',    210000, 195000, 'Approved', 'Cashless',      NULL,                              '2025-04-15', '2025-04-24'),
(13, 3, '2025-05-02', 'Hospitalization',     88000,      0, 'Rejected', NULL,            'Insufficient documentation',      '2025-05-02', '2025-05-20'),
(25, NULL,'2025-03-22', 'Own Damage',         28000,  25000, 'Approved', 'Reimbursement', NULL,                            '2025-03-22', '2025-04-05');

-- ------------------------------------------------------------
-- PAYMENTS (premium payment history, sample subset)
-- ------------------------------------------------------------
INSERT INTO payments (policy_id, payment_date, amount, payment_mode) VALUES
(1,  '2023-04-01', 18500, 'Auto-Debit'),
(1,  '2024-04-01', 18500, 'Auto-Debit'),
(1,  '2025-04-01', 18500, 'Auto-Debit'),
(3,  '2022-08-23', 32000, 'Net Banking'),
(3,  '2023-08-23', 32000, 'Net Banking'),
(3,  '2024-08-23', 32000, 'UPI'),
(4,  '2020-01-15', 45000, 'Cheque'),
(4,  '2021-01-15', 45000, 'Cheque'),
(4,  '2022-01-15', 45000, 'Auto-Debit'),
(4,  '2023-01-15', 45000, 'Auto-Debit'),
(4,  '2024-01-15', 45000, 'Auto-Debit'),
(6,  '2023-11-02', 9500,  'UPI'),
(6,  '2024-11-02', 9500,  'UPI'),
(8,  '2021-03-19', 15000, 'Net Banking'),
(8,  '2022-03-19', 15000, 'Net Banking'),
(8,  '2023-03-19', 15000, 'Auto-Debit'),
(8,  '2024-03-19', 15000, 'Auto-Debit'),
(9,  '2022-09-05', 17500, 'UPI'),
(9,  '2023-09-05', 17500, 'UPI'),
(9,  '2024-09-05', 17500, 'UPI'),
(13, '2021-07-08', 31000, 'Credit Card'),
(13, '2022-07-08', 31000, 'Credit Card'),
(13, '2023-07-08', 31000, 'Credit Card'),
(13, '2024-07-08', 31000, 'Credit Card'),
(17, '2020-03-03', 33000, 'Net Banking'),
(17, '2021-03-03', 33000, 'Net Banking'),
(17, '2022-03-03', 33000, 'Net Banking'),
(17, '2023-03-03', 33000, 'Auto-Debit'),
(17, '2024-03-03', 33000, 'Auto-Debit'),
(18, '2023-09-27', 18000, 'UPI'),
(18, '2024-09-27', 18000, 'UPI');
