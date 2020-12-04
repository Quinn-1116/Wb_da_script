SELECT t1.date,
       t1.appId,
       t2.is_room_owner,
       count(t2.distinct_id)
FROM
  (SELECT date, appId,
                --新注册用户

                appVersion,
                distinct_id
   FROM events
   WHERE event = 'register'
     AND appId IN ('20014',
                   '30015')
     AND appVersion >= '100802'
     AND date = current_date()-interval 1 DAY
   GROUP BY 1,
            2,
            3,
            4) t1
JOIN
  (SELECT date, distinct_id,
                --新注册用户ageType为0的分场

                ageType,
                is_room_owner
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND ageType = '0'
     AND date = current_date()-interval 1 DAY
   GROUP BY 1,
            2,
            3,
            4)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1,
         2,
         3
ORDER BY 1,
         2,
         3