--==================================================================================================
-- 🔹 SECTION 6 — PROFITABILITY AND EFFICIENCY
--==================================================================================================

--Q21. Which loan types generate highest revenue?

SELECT lt.loan_type_name,
       SUM(l.loan_amount * l.interest_rate/100) AS revenue
FROM loans l
JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id
GROUP BY lt.loan_type_name
ORDER BY revenue DESC;

--Q22. High profit vs high risk tradeoff

SELECT lt.loan_type_name,
       SUM(l.loan_amount * l.interest_rate/100) AS revenue,
       AVG(r.default_flag)*100 AS risk
FROM loans l
JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id
JOIN repayments r ON l.loan_id = r.loan_id
GROUP BY lt.loan_type_name
order by risk desc;

--Q23. Revenue by region

SELECT b.region,
       SUM(l.loan_amount * l.interest_rate/100)
FROM loans l
JOIN branches b ON l.branch_id = b.branch_id
GROUP BY b.region;

--Q24. Late payment rate

SELECT 
    ROUND(100.0 * SUM(CASE WHEN payment_status = 'Late' THEN 1 ELSE 0 END)/COUNT(*),2)
FROM repayments;