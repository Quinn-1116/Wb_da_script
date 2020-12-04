
SELECT t1.date,
       t1.appId,
       t2.is_room_owner,
       count(DISTINCT t2.distinct_id)AS user_num,
       count(DISTINCT t2.match_id) AS match_num,
       count(DISTINCT t2.room_id)AS room_num
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
                is_room_owner,
                match_id,
                room_id,
                is_room_owner
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND ageType = '0'
     AND date BETWEEN '2020-11-14' AND current_date()
   GROUP BY 1,
            2,
            3,
            4,
            5,
            6,
            7)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1,
         2,
         3
ORDER BY 1,
         2



SELECT t4.*
FROM
  (SELECT t1.date, t1.distinct_id,
                   t1.appId,
                   t1.appVersion
   FROM
     (SELECT date, appId,
                   appVersion,
                   distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('20014',
                      '30015')
        AND appVersion >= '100802'
        AND date = current_date()
      GROUP BY 1,
               2,
               3,
               4) t1
   JOIN
     (SELECT date, distinct_id,
                   ageType,
                   is_room_owner
      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND ageType = '0'
        AND is_room_owner = 1
        AND date = current_date()
      GROUP BY 1,
               2,
               3,
               4)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   GROUP BY 1,
            2,
            3,
            4) t3
JOIN
  (SELECT date,distinct_id,
               is_room_owner,
               room_id,
               ageType,
               time
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date = current_date()
   GROUP BY 1,
            2,
            3,
            4,
            5,
            6)t4 ON t3.distinct_id = t4.distinct_id
AND t3.date = t4.date
ORDER BY t4.distinct_id,
         t4.time