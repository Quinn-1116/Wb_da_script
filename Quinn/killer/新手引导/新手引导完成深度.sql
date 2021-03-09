
SELECT t1.date,
       count(t1.distinct_id)AS dnu,
       count(t2.distinct_id)AS guide_dnu,
       count(t2.distinct_id)/count(t1.distinct_id)AS guide_rate
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
  (SELECT date,distinct_id,
               count(distinct_id)AS mission_num
   FROM events
   WHERE event = 'cocosEvent'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND cocos_event = 'click'
     AND button_name IN ('clear_asteroids',
                         'fix_wire',
                         'submit_scan',
                         'chart_course66')
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 1



SELECT t1.date, t2.mission_num,
                count(t1.distinct_id)AS dnu,
                count(t2.distinct_id)AS guide_dnu,
                count(t2.distinct_id)/count(t1.distinct_id)AS guide_rate
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
  (SELECT date,distinct_id,
               count(distinct_id)AS mission_num
   FROM events
   WHERE event = 'cocosEvent'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND cocos_event = 'click'
     AND button_name IN ('clear_asteroids',
                         'fix_wire',
                         'submit_scan',
                         'chart_course66')
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1,
         2
ORDER BY 1