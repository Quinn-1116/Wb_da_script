
SELECT t2.pay
FROM
  (SELECT t1.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE gameTypeId = 1800
        AND event = 'gameOver'
        AND gameSubType = '4'
        AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE gameTypeId = 1800
        AND event = 'gameOver'
        AND gameSubType = '4'
        AND detail = 'temple'
        AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL
   GROUP BY 1) t1
JOIN
  (SELECT distinct_id,
          sum(pay)AS pay
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1)t2 ON t1.distinct_id = t2.distinct_id


  
SELECT t2.pay
FROM
  (SELECT distinct_id
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND gameSubType = '4'
     AND detail = 'temple'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1)t1
JOIN
  (SELECT distinct_id,
          sum(pay)AS pay
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1)t2 ON t1.distinct_id = t2.distinct_id