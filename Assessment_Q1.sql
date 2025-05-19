SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    SUM(s.confirmed_amount) / 100 AS total_deposits -- Dividing by 100 to convert from Kobo to Naira
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    plans_plan p ON u.id = p.owner_id
WHERE 
    p.is_a_fund = 1  -- Investment plan filter
    AND s.confirmed_amount > 0  -- Funded savings filter
    AND p.is_regular_savings = 0  -- Ensure it's not a savings plan
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT s.id) >= 1  -- At least one savings
    AND COUNT(DISTINCT p.id) >= 1  -- At least one investment
ORDER BY 
    total_deposits DESC;