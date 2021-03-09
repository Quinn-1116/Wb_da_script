--未玩过兰若寺的老用户回访
SELECT t1.date,
       count(t1.distinct_id),
       count(t2.distinct_id),
       count(t2.distinct_id)/count(t1.distinct_id)as `回访率`
FROM
  (SELECT t1.date,
          t1.distinct_id
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
   WHERE t2.distinct_id IS NULL) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND date BETWEEN '2021-02-02' AND current_date()
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND datediff(t2.date,t1.date) = 1
GROUP BY 1
ORDER BY 1



--玩过兰若寺的老用户回访

SELECT t1.date,
       count(t1.distinct_id),
       count(t2.distinct_id),
       count(t2.distinct_id)/count(t1.distinct_id)AS `回访率`
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND gameSubType = '4'
     AND detail = 'temple'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND date BETWEEN '2021-02-02' AND current_date()
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND datediff(t2.date,t1.date) = 1
GROUP BY 1
ORDER BY 1