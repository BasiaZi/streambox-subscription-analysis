USE streambox;

-- DATA OVERVIEW

SELECT COUNT(*) AS total_subscriptions
FROM subscriptions;

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM subscriptions;

SELECT COUNT(*) AS total_cancellations
FROM subscriptions
WHERE canceled_date <> '';

WITH canceled AS (
				SELECT DATEDIFF(CAST(canceled_date AS DATE), CAST(created_date AS DATE)) AS days_to_cancel
				FROM subscriptions
                WHERE canceled_date <> ''
                )
SELECT COUNT(*) AS early_cancellations
FROM canceled
WHERE days_to_cancel IN (0,1);

-- CANCELLATION TIMING

-- Distribution of cancellations by days since subscription creation
WITH canceled AS (
				SELECT DATEDIFF(CAST(canceled_date AS DATE), CAST(created_date AS DATE)) AS days_to_cancel
				FROM subscriptions
                WHERE canceled_date <> ''
                )
SELECT days_to_cancel, COUNT(*) AS frequency
FROM canceled
GROUP BY days_to_cancel
ORDER BY frequency DESC;

-- Distribution of cancellations as a percentage of all cancellations

WITH canceled AS (
				SELECT  
					DATEDIFF(CAST(canceled_date AS DATE), CAST(created_date AS DATE)) AS days_to_cancel
				FROM subscriptions
				WHERE canceled_date <> ''
                ),
	canceled_by_day AS(
				SELECT days_to_cancel, COUNT(*) AS frequency
				FROM canceled
				GROUP BY days_to_cancel
				)
	SELECT days_to_cancel, frequency, ROUND(frequency*100/SUM(frequency) OVER(), 2) AS percentage
    FROM canceled_by_day
    ORDER BY days_to_cancel;

-- PAYMENT SUCCESS

-- Payment success rate by cancellation timing

WITH canceled AS (
				SELECT DATEDIFF(CAST(canceled_date AS DATE), CAST(created_date AS DATE)) AS days_to_cancel, 
						was_subscription_paid
				FROM subscriptions
                WHERE canceled_date <> ''
                ),
	 payment AS (
				SELECT days_to_cancel, 
						CASE WHEN was_subscription_paid='Yes' THEN 1 ELSE 0 END AS paid_y, 
						CASE WHEN was_subscription_paid='No' THEN 1 ELSE 0 END AS paid_n
				FROM canceled
                        )
SELECT days_to_cancel, 
	COUNT(*) AS subscriptions, 
    SUM(paid_y) AS successful_payments, 
    SUM(paid_n) AS unsuccessful_payments, 
    ROUND(SUM(paid_y)*100/ COUNT(*),2) AS payment_success_rate
FROM payment
GROUP BY days_to_cancel
ORDER BY subscriptions DESC;

-- Payment success rate by cancellation timing, grouped by 0, 1, 2+ days and not canceled

WITH payment AS ( 
		SELECT  DATEDIFF(CAST(canceled_date AS DATE), CAST(created_date AS DATE)) AS days_to_cancel, 
				CASE WHEN was_subscription_paid='Yes' THEN 1 ELSE 0 END AS paid_y
		FROM subscriptions
        ),
	grouped AS (
		SELECT days_to_cancel, paid_y,
				CASE
					WHEN days_to_cancel = 0 THEN 'days_0'
					WHEN days_to_cancel = 1 THEN 'days_1'
					WHEN days_to_cancel >= 2 THEN 'days_2_plus'
					ELSE 'not_canceled'
				END AS cancel_group
		FROM payment
        )
        
SELECT  cancel_group, 
		COUNT(*) AS subscriptions,
		SUM(paid_y) AS successful_payments, 
        ROUND(SUM(paid_y)*100/COUNT(*),2) AS payment_success_rate
FROM grouped
GROUP BY cancel_group
ORDER BY cancel_group;

-- MONTHLY ANALYSIS

-- New subscriptions by month
SELECT YEAR(CAST(created_date AS DATE)) AS yr, 
		MONTH(CAST(created_date AS DATE)) AS mth,
        COUNT(*) AS new_subscriptions
FROM subscriptions
GROUP BY yr, mth
ORDER BY yr, mth;

-- Cancellations by month

SELECT YEAR(CAST(canceled_date AS DATE)) AS yr, 
		MONTH(CAST(canceled_date AS DATE)) AS mth,
        COUNT(*) AS cancellations
FROM subscriptions
WHERE canceled_date <> ''
GROUP BY yr, mth
ORDER BY yr, mth;