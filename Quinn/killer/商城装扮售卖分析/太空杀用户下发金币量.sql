
SELECT t2.date,
       t2.reason,
       sum(t2.amount)
FROM
  (SELECT t3.date,
          t3.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-10-31' AND '2020-12-18'
      GROUP BY 1,
               2) t3
   LEFT JOIN
     (SELECT distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('10001',
                      '10002')
        AND date BETWEEN '2020-10-31' AND '2020-12-18'
      GROUP BY 1)t4 ON t3.distinct_id = t4.distinct_id
   WHERE t4.distinct_id IS NULL)t1
LEFT JOIN
  (SELECT date, distinct_id,
                reason,
                time,
                amount
   FROM events
   WHERE event = 'addMoney'
     AND amount >0
     AND date BETWEEN '2020-10-31' AND '2020-12-18'
   GROUP BY 1,
            2,
            3,
            4,
            5) t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
GROUP BY 1,
         2
ORDER BY 1

 --在太空杀单包充值且未登录过玩吧主包用户的钻石消耗

SELECT t4.date, sum(t4.amount)
FROM
  (SELECT t1.distinct_id
   FROM
     (SELECT distinct_id
      FROM events
      WHERE event = 'pay'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-10-31' AND '2020-12-18'
      GROUP BY 1)t1
   LEFT JOIN
     (SELECT distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('10001',
                      '10002')
        AND date BETWEEN '2020-10-31' AND '2020-12-18'
      GROUP BY 1)t2 ON t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL) t3
LEFT JOIN
  (SELECT date,distinct_id,
               amount,
               time
   FROM events
   WHERE event = 'addDiamond'
     AND amount<0
     AND date BETWEEN '2020-10-31' AND '2020-12-18'
   GROUP BY 1,
            2,
            3,
            4)t4 ON t3.distinct_id = t4.distinct_id
GROUP BY 1
ORDER BY 1


--太空杀单包用户使用金币兑换装扮的金币回收量
SELECT t1.date,
       sum(amount)AS amount
FROM
  (SELECT date, distinct_id,
                goods_name,
                amount,
                time
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'gold'
     AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
     AND date BETWEEN '2020-11-28' AND '2020-12-18'
   GROUP BY 1,
            2,
            3,
            4,
            5
   UNION SELECT date, distinct_id,
                      CASE
                          WHEN goods_name = 'killer_hat_devil' THEN '小恶魔'
                          WHEN goods_name = 'killer_dress_suit' THEN '西装'
                          WHEN goods_name = 'killer_hat_bunny' THEN '幸运兔耳'
                          WHEN goods_name = 'killer_dress_uniforms' THEN '练功服'
                          WHEN goods_name = 'killer_dress_adventure' THEN '探险装'
                          WHEN goods_name = 'killer_hat_aperture' THEN '天使光环'
                          WHEN goods_name = 'killer_hat_pumpkin' THEN '南瓜帽'
                          WHEN goods_name = 'killer_hat_crown' THEN '小皇冠'
                          WHEN goods_name = 'killer_hat_hellowhair' THEN '时尚金发'
                          WHEN goods_name = 'killer_hat_flower' THEN '花盆'
                          WHEN goods_name = 'killer_hat_egg' THEN '煎蛋'
                          WHEN goods_name = 'killer_dress_plumber' THEN '管道工'
                          WHEN goods_name = 'killer_dress_doctor' THEN '白大褂'
                          WHEN goods_name = 'killer_hat_paper' THEN '一卷卷'
                      END AS goods_name,
                      amount,
                      time
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'gold'
     AND goods_name LIKE '%killer%'
     AND date BETWEEN '2020-10-31' AND '2020-11-27'
   GROUP BY 1,
            2,
            3,
            4,
            5)t1
LEFT JOIN
  (SELECT distinct_id
   FROM events
   WHERE event = 'login'
     AND appId in('10001','10002')
     AND date BETWEEN '2020-10-31' AND '2020-12-18'
   GROUP BY 1) t2 ON t1.distinct_id = t2.distinct_id
WHERE t2.distinct_id IS NULL
GROUP BY 1
ORDER BY 1



