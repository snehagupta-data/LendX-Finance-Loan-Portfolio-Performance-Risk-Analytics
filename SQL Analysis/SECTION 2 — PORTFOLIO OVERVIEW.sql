--==================================================================================================
-- 🔹 SECTION 2 — PORTFOLIO OVERVIEW
--==================================================================================================

--Q1. What is the total size of our loan portfolio?

SELECT SUM(loan_amount) AS total_portfolio FROM loans;

--Q2. How many active loans and customers do we have?

SELECT COUNT(DISTINCT loan_id) AS total_loans,
       COUNT(DISTINCT customer_id) AS total_customers
FROM loans;

--Q3. What is the average loan size?

SELECT AVG(loan_amount) AS avg_loan_size FROM loans;

--Q4. Which loan types dominate our portfolio?

SELECT lt.loan_type_name,
       SUM(l.loan_amount) AS total_amount
FROM loans l
JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id
GROUP BY lt.loan_type_name
ORDER BY total_amount DESC;

--Q5. Which regions contribute most to lending?

SELECT b.region,
       SUM(l.loan_amount) AS total_amount
FROM loans l
JOIN branches b ON l.branch_id = b.branch_id
GROUP BY b.region
ORDER BY total_amount DESC;
