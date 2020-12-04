--点击广告的分位数
SELECT date,distinct_id,
            count(distinct_id)AS play_amount
FROM events
WHERE event = 'behavior'
  AND SOURCE = 'video_adv'
  AND gameTypeId = 1800
  AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
GROUP BY 1,
         2