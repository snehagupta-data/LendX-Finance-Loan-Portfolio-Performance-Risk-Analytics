-- ============================================================
-- LOAN PORTFOLIO DATABASE — PostgreSQL DDL
-- Author: Senior Data Analyst
-- Version: 1.0
-- Description: Production-ready schema for loan analytics
-- ============================================================

-- ─────────────────────────────────────────
-- DROP ORDER: dependents first
-- ─────────────────────────────────────────
DROP TABLE IF EXISTS repayments   CASCADE;
DROP TABLE IF EXISTS loans        CASCADE;
DROP TABLE IF EXISTS customers    CASCADE;
DROP TABLE IF EXISTS loan_types   CASCADE;
DROP TABLE IF EXISTS branches     CASCADE;

-- ─────────────────────────────────────────
-- 1. DIMENSION: branches
-- ─────────────────────────────────────────
CREATE TABLE branches (
    branch_id     VARCHAR(10)  NOT NULL,
    branch_name   VARCHAR(100) NOT NULL,
    city          VARCHAR(50)  NOT NULL,
    state         VARCHAR(50)  NOT NULL,
    region        VARCHAR(20)  NOT NULL
                  CHECK (region IN ('North','South','East','West')),

    CONSTRAINT pk_branches PRIMARY KEY (branch_id)
);

-- ─────────────────────────────────────────
-- 2. DIMENSION: loan_types
-- ─────────────────────────────────────────
CREATE TABLE loan_types (
    loan_type_id   VARCHAR(10)  NOT NULL,
    loan_type_name VARCHAR(50)  NOT NULL,
    risk_level     VARCHAR(10)  NOT NULL
                   CHECK (risk_level IN ('Low','Medium','High')),

    CONSTRAINT pk_loan_types PRIMARY KEY (loan_type_id)
);

-- ─────────────────────────────────────────
-- 3. DIMENSION: customers
-- ─────────────────────────────────────────
CREATE TABLE customers (
    customer_id      VARCHAR(10)  NOT NULL,
    customer_name    VARCHAR(100) NOT NULL,
    age              SMALLINT     NOT NULL CHECK (age BETWEEN 18 AND 100),
    gender           VARCHAR(10)  NOT NULL CHECK (gender IN ('Male','Female','Other')),
    city             VARCHAR(50)  NOT NULL,
    state            VARCHAR(50)  NOT NULL,
    employment_type  VARCHAR(20)  NOT NULL
                     CHECK (employment_type IN ('Salaried','Self-Employed','Business')),
    salary           NUMERIC(12,2) NOT NULL CHECK (salary > 0),
    credit_score     SMALLINT      NOT NULL CHECK (credit_score BETWEEN 300 AND 900),
    customer_since   DATE          NOT NULL,

    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
);

-- ─────────────────────────────────────────
-- 4. FACT: loans
-- ─────────────────────────────────────────
CREATE TABLE loans (
    loan_id         VARCHAR(10)   NOT NULL,
    customer_id     VARCHAR(10)   NOT NULL,
    branch_id       VARCHAR(10)   NOT NULL,
    loan_type_id    VARCHAR(10)   NOT NULL,
    loan_amount     NUMERIC(14,2) NOT NULL CHECK (loan_amount > 0),
    interest_rate   NUMERIC(5,2)  NOT NULL CHECK (interest_rate > 0),
    loan_date       DATE          NOT NULL,
    tenure_months   SMALLINT      NOT NULL CHECK (tenure_months > 0),

    CONSTRAINT pk_loans          PRIMARY KEY (loan_id),
    CONSTRAINT fk_loans_customer FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id) ON DELETE RESTRICT,
    CONSTRAINT fk_loans_branch   FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)   ON DELETE RESTRICT,
    CONSTRAINT fk_loans_type     FOREIGN KEY (loan_type_id)
        REFERENCES loan_types(loan_type_id) ON DELETE RESTRICT
);

-- ─────────────────────────────────────────
-- 5. FACT: repayments
-- ─────────────────────────────────────────
CREATE TABLE repayments (
    payment_id      VARCHAR(10)   NOT NULL,
    loan_id         VARCHAR(10)   NOT NULL,
    due_date        DATE          NOT NULL,
    payment_date    DATE          NOT NULL,
    payment_amount  NUMERIC(12,2) NOT NULL CHECK (payment_amount >= 0),
    payment_status  VARCHAR(10)   NOT NULL
                    CHECK (payment_status IN ('On-time','Late','Default')),
    penalty_amount  NUMERIC(10,2) NOT NULL DEFAULT 0
                    CHECK (penalty_amount >= 0)

);

--=================================================================================================
--Add Derived Columns 
--=================================================================================================

--Add default_flag column 

ALTER TABLE repayments
ADD COLUMN default_flag INT 
GENERATED ALWAYS AS (
    CASE 
        WHEN payment_status = 'Default' THEN 1 
        ELSE 0 
    END
) STORED;

--Add delay_days column 

ALTER TABLE repayments
ADD COLUMN delay_days INT 
GENERATED ALWAYS AS (
    CASE 
        WHEN payment_date IS NOT NULL 
        THEN payment_date - due_date
        ELSE NULL
    END
) STORED;