--==================================================================================================
-- 🔹 SECTION 5— RISK & DEFAULT ANALYSIS
--==================================================================================================

--Q16. What is the overall default rate?

SELECT ROUND(100.0 * SUM(default_flag) / COUNT(*),2) AS default_rate
FROM repayments;

--Q17. Which loan types have highest default risk?

SELECT lt.loan_type_name,
       round(AVG(r.default_flag)*100,2) || ' % ' AS default_rate
FROM repayments r
JOIN loans l ON r.loan_id = l.loan_id
JOIN loan_types lt ON l.loan_type_id = lt.loan_type_id
GROUP BY lt.loan_type_name
ORDER BY AVG(r.default_flag) DESC;

--Q18. Does credit score actually predict default?

SELECT 
    CASE 
        WHEN c.credit_score < 500 THEN 'Low'
        WHEN c.credit_score < 650 THEN 'Medium'
        ELSE 'High'
    END,
    AVG(r.default_flag) * 100
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
JOIN repayments r ON l.loan_id = r.loan_id
GROUP BY 1;

--Q19. Which regions have highest default rates?

SELECT b.region,
       AVG(r.default_flag) * 100 as default_rate
FROM repayments r
JOIN loans l ON r.loan_id = l.loan_id
JOIN branches b ON l.branch_id = b.branch_id
GROUP BY b.region;

--Q20. Are larger loans riskier?

SELECT 
    CASE 
        WHEN loan_amount < 50000 THEN 'Small'
        WHEN loan_amount < 500000 THEN 'Medium'
        ELSE 'Large'
    END,
    AVG(r.default_flag) * 100 as default_rate
FROM loans l
JOIN repayments r ON l.loan_id = r.loan_id
GROUP BY 1;

