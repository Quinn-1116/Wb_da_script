
SELECT t5.date,
       t6.gameTypeId,
       t6.reason,
       sum(t6.amount)AS amount
FROM
  (SELECT t1.date,
          t1.distinct_id
   FROM
     (SELECT t3.date,
             t3.distinct_id
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN '2020-10-31' AND '2020-12-18'
         GROUP BY 1,
                  2) t3
      LEFT JOIN
        (SELECT distinct_id
         FROM events
         WHERE event = 'login'
           AND appId IN ('10001',
                         '10002')
           AND date BETWEEN '2020-10-31' AND '2020-12-18'
         GROUP BY 1)t4 ON t3.distinct_id = t4.distinct_id
      WHERE t4.distinct_id IS NULL)t1--仅单包用户

   JOIN
     (SELECT date, distinct_id,
                   reason,
                   time,
                   amount
      FROM events
      WHERE event = 'addMoney'
        AND amount >0
        AND reason = 'diamond_buy'
      GROUP BY 1,
               2,
               3,
               4,
               5)t2 ON t1.distinct_id = t2.distinct_id--使用钻石兑换了金币
AND t1.date = t2.date)t5
JOIN
  (SELECT date, distinct_id,
                reason,
                gameTypeId,
                sum(amount)AS amount
   FROM events
   WHERE event = 'addMoney'
     AND amount <0
     AND date BETWEEN '2020-10-31' AND '2020-12-18'
   GROUP BY 1,
            2,
            3,
            4) t6 ON t5.distinct_id = t6.distinct_id
AND t5.date = t6.date
GROUP BY 1,
         2,
         3