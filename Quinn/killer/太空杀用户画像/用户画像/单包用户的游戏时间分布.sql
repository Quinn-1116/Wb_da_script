
SELECT count(distinct t1.distinct_id)
FROM
  (SELECT t2.distinct_id,
          t2.week_day
   FROM
     (SELECT distinct_id
      FROM user_group_user_group_tks_label_7
      GROUP BY 1)t1
   JOIN
     (SELECT distinct_id, date,DAYOFWEEK(date)AS week_day
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-12-26' AND '2021-01-25'
      GROUP BY 1,
               2,
               3) t2 ON t1.distinct_id = t2.distinct_id
   WHERE t2.week_day IN (1,
                         6,
                         7)
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT t2.distinct_id,
          t2.week_day
   FROM
     (SELECT distinct_id
      FROM user_group_user_group_tks_label_7
      GROUP BY 1)t1
   JOIN
     (SELECT distinct_id, date,DAYOFWEEK(date)AS week_day
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-12-26' AND '2021-01-25'
      GROUP BY 1,
               2,
               3) t2 ON t1.distinct_id = t2.distinct_id
   WHERE t2.week_day IN (2,
                         3,
                         4,
                         5)
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
WHERE t2.distinct_id IS NULL