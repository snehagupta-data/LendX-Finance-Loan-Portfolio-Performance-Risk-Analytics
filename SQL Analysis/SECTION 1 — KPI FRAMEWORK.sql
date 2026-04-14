--==================================================================================================
-- 🔹 SECTION 1 — KPI FRAMEWORK
--==================================================================================================

--1. Total Portfolio Value

SELECT SUM(loan_amount) FROM loans;

--2. Average Loan Size

SELECT AVG(loan_amount) FROM loans;

--3. Active Loans Count

SELECT COUNT(*) FROM loans;

--4. Default Rate %

SELECT 100.0 * SUM(default_flag)/COUNT(*) FROM repayments;

--5. NPA (Non-Performing Asset %)

SELECT 
SUM(CASE WHEN payment_status = 'Default' THEN payment_amount ELSE 0 END)
/ SUM(payment_amount)
FROM repayments;

--6. Delinquency Rate

SELECT 
100.0 * SUM(CASE WHEN payment_status = 'Late' THEN 1 ELSE 0 END)/COUNT(*)
FROM repayments;

--7. Portfolio Yield

SELECT 
SUM(loan_amount * interest_rate/100) / SUM(loan_amount)
FROM loans;

--8. Revenue

SELECT SUM(loan_amount * interest_rate/100) FROM loans;

--9. Collection Efficiency

SELECT 
SUM(payment_amount) / SUM(loan_amount)
FROM repayments r
JOIN loans l ON r.loan_id = l.loan_id;

--10. Avg Delay Days

SELECT AVG(delay_days) FROM repayments;

--11. Avg Credit Score

SELECT AVG(credit_score) FROM customers;

--12. High-Risk Customer %

SELECT 
100.0 * COUNT(*) FILTER (WHERE credit_score < 600) / COUNT(*)
FROM customers;

