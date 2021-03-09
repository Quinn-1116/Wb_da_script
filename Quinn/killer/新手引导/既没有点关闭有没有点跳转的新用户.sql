
SELECT t1.date,
       t1.dnu,
       t2.`既没有点关闭也没有点跳转的新用户量`
FROM
  (SELECT date,count(DISTINCT distinct_id)AS dnu
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-12-01' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1)t1
JOIN
  (SELECT t1.date, count(DISTINCT t1.distinct_id)AS `既没有点关闭也没有点跳转的新用户量`
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND date BETWEEN '2020-12-01' AND CURRENT_DATE() - interval 1 DAY
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2) t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'advClick'
        AND button_name in('exit','adv')
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
        AND adv_id = 'b_killer_newuserlead_201217'
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2) t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1



--这波用户的进房率
SELECT t1.date,
       count(DISTINCT t1.distinct_id)AS `既没有点关闭也没有点跳转的用户量`,
       count(DISTINCT t2.distinct_id) AS `进房用户数`,
       count(DISTINCT t3.distinct_id) AS `开始游戏用户数`
FROM
  (SELECT t1.date,
          t1.distinct_id
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
        AND button_name in('exit','adv')
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
        AND adv_id = 'b_killer_newuserlead_201217'
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2) t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'roomAllocate'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND gameTypeId = 1800
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND gameTypeId = 1800
     AND gameSubType = '1'
     AND game_played = 0
   GROUP BY 1,
            2)t3 ON t1.date = t3.date
AND t1.distinct_id = t3.distinct_id
AND t2.distinct_id = t3.distinct_id
GROUP BY 1
ORDER BY 1