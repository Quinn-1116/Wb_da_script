-- <!-- 每日任务下发、完成、领取奖励、双倍奖励领取 -->

SELECT t1.date,
       count(t7.distinct_id)AS game_dau,
       count(t1.distinct_id)AS dispatch_num,
       count(t1.distinct_id)/count(t7.distinct_id)AS dispatch_rate,
       count(t2.distinct_id)AS finish_num,
       count(t2.distinct_id)/count(t1.distinct_id) AS finish_rate,
       count(t3.distinct_id)AS completed_num,
       count(t3.distinct_id)/count(t2.distinct_id) AS completed_rate,
       count(t4.distinct_id)AS double_award_click,
       count(t4.distinct_id)/count(t3.distinct_id) AS double_click_rate,
       count(t5.distinct_id)AS video_play_num,
       count(t5.distinct_id)/count(t4.distinct_id) AS play_rate,
       count(t6.distinct_id)AS double_award_num,
       count(t6.distinct_id)/count(t5.distinct_id)AS double_award_rate
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId in('20014','30015')
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t7
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'dispatch'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t1 ON t1.distinct_id = t7.distinct_id
AND t1.date = t7.date
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'finish'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'complete'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t3 ON t2.date = t3.date
AND t2.distinct_id = t3.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'trackClick'
     AND button_name = 'h5_popup'
     AND button_detail = 'double_award'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t4 ON t3.date = t4.date
AND t3.distinct_id = t4.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t5 ON t4.date = t5.date
AND t4.distinct_id = t5.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'addMoney'
     AND reason = 'killer_ad_awards'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t6 ON t5.date = t6.date
AND t5.distinct_id = t6.distinct_id
GROUP BY 1
ORDER BY 1




SELECT t1.date,
       count(t1.distinct_id)AS dnu,
       count(t2.distinct_id)dispatch_num,
       count(t2.distinct_id)/count(t1.distinct_id)AS dispatch_rate,
       count(t3.distinct_id)AS `任务完成用户数`,
       count(t3.distinct_id)/count(t2.distinct_id) AS `完成转化率`,
       count(t4.distinct_id)AS `领取奖励用户数`,
       count(t4.distinct_id)/count(t3.distinct_id) AS `奖励领取率`,
       count(t5.distinct_id)AS double_award_click,
       count(t5.distinct_id)/count(t4.distinct_id)AS double_award_click_rate,
       count(t6.distinct_id)AS video_play_num,
       count(t6.distinct_id)/count(t5.distinct_id)AS video_play_rate,
       count(t7.distinct_id)AS double_award_num,
       count(t7.distinct_id)/count(t6.distinct_id)AS double_award_rate
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'dispatch'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'finish'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t3 ON t2.date = t3.date
AND t2.distinct_id = t3.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'complete'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t4 ON t3.date = t4.date
AND t3.distinct_id = t4.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'trackClick'
     AND button_name = 'h5_popup'
     AND button_detail = 'double_award'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t5 ON t4.date = t5.date
AND t4.distinct_id = t5.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t6 ON t5.date = t6.date
AND t5.distinct_id = t6.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'addMoney'
     AND reason = 'killer_ad_awards'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t7 ON t6.date = t7.date
AND t6.distinct_id = t7.distinct_id
GROUP BY 1
ORDER BY 1






SELECT t9.date,
       count(t9.distinct_id)AS app_dou,
       count(t1.distinct_id)AS dispatch_num,
       count(t1.distinct_id)/count(t9.distinct_id)AS dispatch_rate,
       count(t2.distinct_id)AS finish_num,
       count(t2.distinct_id)/count(t1.distinct_id) AS finish_rate,
       count(t3.distinct_id)AS completed_num,
       count(t3.distinct_id)/count(t2.distinct_id) AS completed_rate,
       count(t4.distinct_id)AS double_award_click,
       count(t4.distinct_id)/count(t3.distinct_id) AS double_click_rate,
       count(t5.distinct_id)AS video_play_num,
       count(t5.distinct_id)/count(t4.distinct_id) AS play_rate,
       count(t6.distinct_id)AS double_award_num,
       count(t6.distinct_id)/count(t5.distinct_id)AS double_award_rate
FROM
  (SELECT t7.date,
          t7.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId in('20014','30015')
        AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2) t7
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND appId in('20014','30015')
        AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t8 ON t7.date = t8.date
   AND t7.distinct_id = t8.distinct_id
   WHERE t8.distinct_id IS NULL
   GROUP BY 1,
            2)t9
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'dispatch'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t1 ON t1.distinct_id = t9.distinct_id
AND t1.date = t9.date
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'finish'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'complete'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t3 ON t2.date = t3.date
AND t2.distinct_id = t3.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'trackClick'
     AND button_name = 'h5_popup'
     AND button_detail = 'double_award'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t4 ON t3.date = t4.date
AND t3.distinct_id = t4.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t5 ON t4.date = t5.date
AND t4.distinct_id = t5.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'addMoney'
     AND reason = 'killer_ad_awards'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t6 ON t5.date = t6.date
AND t5.distinct_id = t6.distinct_id
GROUP BY 1
ORDER BY 1