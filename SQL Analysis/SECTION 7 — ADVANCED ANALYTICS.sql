--==================================================================================================
-- 🔹 SECTION 7 — ADVANCED ANALYTICS
--==================================================================================================

--25. Top customers contributing to revenue

SELECT 
    customer_id,
    SUM(loan_amount) AS total_loan,
    DENSE_RANK() OVER (ORDER BY SUM(loan_amount) DESC) AS customer_rank
FROM loans
GROUP BY customer_id;

--26. Is a branch performing above or below average?

SELECT 
    b.branch_name,
    SUM(l.loan_amount) AS branch_total,
    AVG(SUM(l.loan_amount)) OVER () AS overall_avg,
   
FROM loans l
JOIN branches b ON l.branch_id = b.branch_id
GROUP BY b.branch_name;

--27. Portfolio growth over time

SELECT 
    DATE_TRUNC('month', loan_date) AS month,
    SUM(loan_amount) AS monthly_disbursal,
    SUM(SUM(loan_amount)) OVER (ORDER BY DATE_TRUNC('month', loan_date)) AS cumulative_portfolio
FROM loans
GROUP BY month
ORDER BY month;

--28. Is delay increasing for a customer? → early warning

SELECT 
    loan_id,
    due_date,
    delay_days,
    LAG(delay_days) OVER (PARTITION BY loan_id ORDER BY due_date) AS prev_delay,
    delay_days - LAG(delay_days) OVER (PARTITION BY loan_id ORDER BY due_date) AS delay_change
FROM repayments;


--29. TOP LOAN PER REGION

SELECT *
FROM (
    SELECT 
        b.region,
        l.loan_id,
        l.loan_amount,
        ROW_NUMBER() OVER (PARTITION BY b.region ORDER BY l.loan_amount DESC) AS rn
    FROM loans l
    JOIN branches b ON l.branch_id = b.branch_id
) t
WHERE rn = 1;

-- 30. BRANCH PERFORMANCE VS PORTFOLIO AVERAGE

SELECT 
    b.branch_name,
    SUM(l.loan_amount) AS total_business,
    AVG(r.default_flag) AS default_rate,

    -- Compare with overall avg
    AVG(AVG(r.default_flag)) OVER () AS overall_default,

    CASE 
        WHEN AVG(r.default_flag) > AVG(AVG(r.default_flag)) OVER ()
        THEN 'High Risk Branch'
        ELSE 'Stable Branch'
    END AS branch_status

FROM loans l
JOIN branches b ON l.branch_id = b.branch_id
JOIN repayments r ON l.loan_id = r.loan_id
GROUP BY b.branch_name;