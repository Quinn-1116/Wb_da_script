SELECT date,is_first_pay,
            pay,
            count(distinct_id)
FROM events
WHERE event = 'pay'
  AND appId IN ('20014',
                '30015')
  AND date BETWEEN '2020-10-31' AND '2020-12-18'
GROUP BY 1,
         2,
         3


SELECT date,is_first_pay,
            pay,
            count(distinct_id)
FROM events
WHERE event = 'pay'
  AND appId IN ('10001',
                '10002')
  AND date BETWEEN '2020-10-31' AND '2020-12-18'
GROUP BY 1,
         2,
         3