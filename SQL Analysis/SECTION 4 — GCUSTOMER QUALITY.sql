--==================================================================================================
-- 🔹 SECTION 4 — GCUSTOMER QUALITY
--==================================================================================================

--Q11. Do high-income customers take larger loans?

SELECT 
    CASE 
        WHEN salary < 300000 THEN 'Low'
        WHEN salary < 1000000 THEN 'Medium'
        ELSE 'High'
    END AS income_band,
    AVG(loan_amount) as avg_loan_amount
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY income_band;

--Q12. Credit score distribution of customers

SELECT 
    CASE 
        WHEN credit_score < 500 THEN 'Poor'
        WHEN credit_score < 650 THEN 'Average'
        ELSE 'Good'
    END AS score_band,
    COUNT(*)
FROM customers
GROUP BY score_band;

--Q13. Which employment type borrows the most?

SELECT employment_type,
       SUM(l.loan_amount)
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY employment_type;

--Q14. Are new customers riskier than old customers?

SELECT 
    CASE 
        WHEN customer_since > (DATE '2023-12-29' - INTERVAL '1 years') THEN 'New'
        ELSE 'Old'
    END AS customer_type,
    AVG(r.default_flag) as avg_default_flag
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN repayments r ON l.loan_id = r.loan_id
GROUP BY customer_type;

--Q15. Gender-based borrowing behavior

SELECT gender,
       AVG(loan_amount)
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY gender;


