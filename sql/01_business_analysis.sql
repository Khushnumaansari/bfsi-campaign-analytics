CREATE DATABASE Bank_Term_Deposit_Campaign;
GO

USE Bank_Term_Deposit_Campaign;
GO

SELECT * FROM fact_experiment

-- Overall conversion

SELECT COUNT(*) AS total_customers_contacted,
SUM(CAST(converted AS INT)) AS total_conversions,
CAST(ROUND(100.0 * SUM(CAST(converted AS INT)) / COUNT(*), 2) AS DECIMAL(10,2)) AS conversion_rate_pct
FROM fact_experiment;


-- Campaign version performance
SELECT c.campaign_version,
COUNT(*) AS customers_contacted,
SUM(CAST(converted AS INT)) AS total_conversions,
CAST(ROUND(100.0 * SUM(CAST(converted AS INT)) / COUNT(*), 2) AS DECIMAL(10,2)) AS conversion_rate_pct
FROM fact_experiment f
JOIN dim_campaign c
	ON f.campaign_id = c.campaign_id
GROUP BY c.campaign_version
ORDER BY conversion_rate_pct DESC


-- Channel performance
SELECT c.channel,
COUNT(*) AS customers_contacted,
SUM(CAST(converted AS INT)) AS total_conversions,
CAST(ROUND(100.0 * SUM(CAST(converted AS INT)) / COUNT(*), 2) AS DECIMAL(10,2)) AS conversion_rate_pct
FROM fact_experiment f
JOIN dim_campaign c
	ON f.campaign_id = c.campaign_id
GROUP BY c.channel
ORDER BY conversion_rate_pct DESC;


-- Customer segment performance
SELECT TOP 15 c.age_group,
c.job,
c.education,
COUNT(*) AS customers_contacted,
SUM(CAST(converted AS INT)) AS total_conversions,
CAST(ROUND(100.0 * SUM(CAST(converted AS INT)) / COUNT(*), 2) AS DECIMAL(10,2)) AS conversion_rate_pct
FROM fact_experiment f
JOIN dim_customer c
	ON f.customer_id = c.customer_id
GROUP BY c.age_group, c.job, c.education
ORDER BY conversion_rate_pct DESC;


-- Campaign finance performance

SELECT c.campaign_version,
c.channel,
SUM(cost.customers_contacted) AS customers_contacted,
SUM(cost.conversions) AS conversions,
SUM(cost.planned_budget) AS planned_budget,
SUM(cost.actual_spend) AS actual_spend,
SUM(cost.budget_variance) AS budget_variance,
SUM(cost.estimated_contribution) AS estimated_contribution,
SUM(cost.estimated_profit) AS estimated_profit
FROM fact_campaign_cost cost
JOIN dim_campaign c
	ON cost.campaign_id = c.campaign_id
GROUP BY c.campaign_version, c.channel
ORDER BY estimated_profit DESC;


-- High probability customers
SELECT TOP 25 *
FROM dim_customer c
JOIN ml_scores m
	ON c.customer_id = m.customer_id