WITH customer_stats AS (
    SELECT
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        AVG(s.confirmed_amount) AS avg_transaction_amount
    FROM
        users_customuser u
    LEFT JOIN
        savings_savingsaccount s ON u.id = s.owner_id
    WHERE
        s.confirmed_amount > 0  -- Only funded transactions
    GROUP BY
        u.id, u.first_name, u.last_name, u.date_joined
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    ROUND(
        (total_transactions / NULLIF(tenure_months, 0)) * 12 * 
        (avg_transaction_amount * 0.001),  -- 0.1% profit per transaction
        2
    ) AS estimated_clv
FROM
    customer_stats
WHERE
    tenure_months > 0  -- Exclude newly created accounts
ORDER BY
    estimated_clv DESC;