--==================================================================================================
-- 🔹 SECTION 3 — GROWTH & DISTRIBUTION
--==================================================================================================

--Q6. How is loan disbursement trending over time?

SELECT DATE_TRUNC('month', loan_date) AS month,
       SUM(loan_amount) AS disbursed
FROM loans
GROUP BY month
ORDER BY month;

--Q7. Which branches are driving the most business?

SELECT b.branch_name,
       SUM(l.loan_amount) AS total_business
FROM loans l
JOIN branches b ON l.branch_id = b.branch_id
GROUP BY b.branch_name
ORDER BY total_business DESC;

--Q8. Are we over-dependent on a few customers?

SELECT 
    customer_id,
    SUM(loan_amount) AS total_loan,
    round(SUM(loan_amount) * 100.0 / SUM(SUM(loan_amount)) OVER (),2) || ' %' AS contribution_pct
FROM loans
GROUP BY customer_id
ORDER BY total_loan DESC;

--Q9. What is the distribution of loan tenure?

SELECT tenure_months,
       COUNT(*) 
FROM loans
GROUP BY tenure_months
ORDER BY tenure_months;

--Q10. Which cities are high lending zones?

SELECT c.city,
       SUM(l.loan_amount)
FROM loans l
JOIN customers c ON l.customer_id = c.customer_id
GROUP BY c.city
ORDER BY SUM(l.loan_amount) DESC;

