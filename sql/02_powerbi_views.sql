CREATE VIEW vw_campaign_performance AS
SELECT c.campaign_version,
c.channel,
COUNT(*) AS customers_contacted,
SUM(CAST(converted AS INT)) AS total_conversions,
CAST(ROUND(100.0 * SUM(CAST(converted AS INT)) / COUNT(*), 2) AS DECIMAL(10,2)) AS conversion_rate_pct
FROM fact_experiment f
JOIN dim_campaign c
	ON f.campaign_id = c.campaign_id
GROUP BY c.campaign_version, c.channel


CREATE VIEW vw_customers_targeting AS
SELECT d.age_group,
d.job,
d.education,
d.housing,
d.loan,
COUNT(*) AS customers_contacted,
SUM(CAST(converted AS INT)) AS total_conversions,
CAST(ROUND(100.0 * SUM(CAST(converted AS INT)) / COUNT(*), 2) AS DECIMAL(10,2)) AS conversion_rate_pct
FROM fact_experiment f
JOIN dim_customer d
	ON f.customer_id = d.customer_id
GROUP BY d.age_group, d.job, d.education, d.housing, d.loan


CREATE VIEW vw_finance_performance AS
SELECT c.campaign_version,
c.channel,
c.month_name,
c.month_num,
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
GROUP BY c.campaign_version, c.channel, c.month_name, c.month_num



CREATE VIEW vw_leads_scores AS
SELECT d.customer_id,
d.age,
d.age_group,
d.job,
d.education,
d.housing,
d.loan,
m.conversion_probability,
m.lead_score_band
FROM dim_customer d
JOIN ml_scores m
	ON d.customer_id = m.customer_id
GROUP BY d.customer_id, d.age, d.age_group, d.job, d.education, d.housing, d.loan, m.conversion_probability, m.lead_score_band