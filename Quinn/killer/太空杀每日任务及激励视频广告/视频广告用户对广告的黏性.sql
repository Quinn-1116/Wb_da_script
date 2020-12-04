
SELECT t3.date,
       t3.ad_num,
       t4.date_gap,
       t4.retention_num,
       t4.retention_num/t3.ad_num
FROM
  (SELECT date, count(DISTINCT distinct_id)AS ad_num
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
   GROUP BY 1) t3
JOIN
  (SELECT t1.date, datediff(t2.date,t1.date) AS date_gap,
                   count(t2.distinct_id)AS retention_num
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'behavior'
        AND SOURCE = 'video_adv'
        AND gameTypeId = 1800
        AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'behavior'
        AND SOURCE = 'video_adv'
        AND gameTypeId = 1800
        AND date BETWEEN '2020-11-21' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND datediff(t2.date,t1.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2)t4 ON t3.date = t4.date
ORDER BY 1,
         3



SELECT t3.date,
       t3.ad_num,
       t4.date_gap,
       t4.retention_num,
       t4.retention_num/t3.ad_num
FROM
  (SELECT date, count(DISTINCT distinct_id)AS ad_num
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1004
     AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
   GROUP BY 1) t3
JOIN
  (SELECT t1.date, datediff(t2.date,t1.date) AS date_gap,
                   count(t2.distinct_id)AS retention_num
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'behavior'
        AND SOURCE = 'video_adv'
        AND gameTypeId = 1004
        AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'behavior'
        AND SOURCE = 'video_adv'
        AND gameTypeId = 1004
        AND date BETWEEN '2020-11-21' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND datediff(t2.date,t1.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2)t4 ON t3.date = t4.date
ORDER BY 1,
         3



SELECT t3.date,
       t3.ad_num,
       t4.date_gap,
       t4.retention_num,
       t4.retention_num/t3.ad_num
FROM
  (SELECT date, count(DISTINCT distinct_id)AS ad_num
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1180
     AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
   GROUP BY 1) t3
JOIN
  (SELECT t1.date, datediff(t2.date,t1.date) AS date_gap,
                   count(t2.distinct_id)AS retention_num
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'behavior'
        AND SOURCE = 'video_adv'
        AND gameTypeId = 1180
        AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'behavior'
        AND SOURCE = 'video_adv'
        AND gameTypeId = 1180
        AND date BETWEEN '2020-11-21' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND datediff(t2.date,t1.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2)t4 ON t3.date = t4.date
ORDER BY 1,
         3