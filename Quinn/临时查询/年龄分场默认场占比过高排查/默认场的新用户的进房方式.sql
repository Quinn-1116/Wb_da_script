SELECT t4.date,
       t4.enter_source,
       count(DISTINCT t4.distinct_id)
FROM
  (SELECT t1.date,
          t1.distinct_id,
          t2.room_id
   FROM
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('20014',
                      '30015')
        AND appVersion >= '100802'
        AND date BETWEEN '2020-11-14' AND current_date()-interval 1 DAY
      GROUP BY 1,
               2) t1
   JOIN
     (SELECT date, distinct_id,
                   ageType,
                   is_room_owner,
                   room_id
      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND ageType = '0'
        AND date BETWEEN '2020-11-14' AND current_date()-interval 1 DAY
      GROUP BY 1,
               2,
               3,
               4,
               5)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   GROUP BY 1,
            2,
            3)t3
JOIN
  (SELECT date, distinct_id,
                room_id,
                enter_source
   FROM events
   WHERE event = 'roomAllocate'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-14' AND current_date()-interval 1 DAY
   GROUP BY 1,
            2,
            3,
            4)t4 ON t3.date = t4.date
AND t3.distinct_id = t4.distinct_id
AND t3.room_id = t4.room_id
GROUP BY 1,
         2
ORDER BY 1


SELECT t1.date,
       t2.ageType,
       count(DISTINCT t2.match_id) AS match_num
FROM
  (SELECT date, appId,
                distinct_id
   FROM events
   WHERE event = 'register'
     AND appId IN ('20014',
                   '30015')
     AND appVersion >= '100802'
     AND date BETWEEN '2020-11-14' AND current_date()
   GROUP BY 1,
            2,
            3) t1
JOIN
  (SELECT date, distinct_id,
                ageType,
                match_id,
                room_id,
                is_room_owner
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-14' AND current_date()
   GROUP BY 1,
            2,
            3,
            4,
            5,
            6)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1,2
ORDER BY 1