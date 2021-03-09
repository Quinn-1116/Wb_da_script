--点击新手引导的用户的游戏漏斗
SELECT t1.date,
       count(distinct t1.distinct_id)AS dnu,
       count(distinct t2.distinct_id)AS `点击新手引导用户数`,
       count(distinct t3.distinct_id)AS `进入房间用户数`,
       count(distinct t4.distinct_id)AS `游戏用户数`
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'advClick'
     AND button_name = 'adv'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND adv_id = 'b_killer_newuserlead_201217'
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'roomAllocate'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND gameTypeId = 1800
   GROUP BY 1,
            2)t3 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
AND t2.distinct_id = t3.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND gameTypeId = 1800
     AND gameSubType = '1'
     AND game_played = 0
   GROUP BY 1,
            2)t4 ON t1.date = t4.date
AND t1.distinct_id = t4.distinct_id
AND t2.distinct_id = t4.distinct_id
AND t3.distinct_id = t4.distinct_id
GROUP BY 1
ORDER BY 1

--关闭了新手引导的用户的游戏漏斗
SELECT t1.date, count(distinct t1.distinct_id)AS dnu,
                count(distinct t2.distinct_id)AS exit_num,
                count(distinct t3.distinct_id)AS `进入房间用户数`,
                count(distinct t4.distinct_id)AS `游戏用户数`
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'advClick'
     AND button_name = 'exit'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND adv_id = 'b_killer_newuserlead_201217'
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'roomAllocate'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND gameTypeId = 1800
   GROUP BY 1,
            2)t3 ON t1.date = t3.date
AND t1.distinct_id = t3.distinct_id
and t2.distinct_id = t3.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND gameTypeId = 1800
     AND gameSubType = '1'
     AND game_played = 0
   GROUP BY 1,
            2)t4 ON t1.date = t4.date
AND t1.distinct_id = t4.distinct_id
and t2.distinct_id= t4.distinct_id
AND t3.distinct_id = t4.distinct_id
GROUP BY 1
ORDER BY 1