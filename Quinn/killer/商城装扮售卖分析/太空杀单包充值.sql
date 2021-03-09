
SELECT t1.date,
       t2.dau,
       t1.`充值用户数`,
       t1.`充值总金额`
FROM
  (SELECT date, count(distinct_id) AS `充值用户数`,
                sum(pay) AS `充值总金额`
   FROM events
   WHERE event = 'pay'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-10-31' AND '2020-12-18'
   GROUP BY 1)t1
JOIN
  (SELECT date,count(DISTINCT distinct_id) AS dau
   FROM events
   WHERE event = 'login'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-10-31' AND '2020-12-18'
   GROUP BY 1)t2 ON t1.date = t2.date
  order by 1