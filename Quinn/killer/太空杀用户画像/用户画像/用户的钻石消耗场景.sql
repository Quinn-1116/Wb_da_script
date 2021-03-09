-- 用户的钻石消耗场景.sql
-- 按照reason，gameTypeId查看

SELECT t2.reason_diamond,
       sum(t2.amount)AS amount
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_5
   GROUP BY 1)t1
LEFT JOIN
  (SELECT distinct_id,reason_diamond,-sum(amount)AS amount
   FROM events
   WHERE event = 'addDiamond'
     AND amount <0
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 2 DESC


SELECT t2.gameTypeId,
       sum(t2.amount)AS amount
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_5
   GROUP BY 1)t1
LEFT JOIN
  (SELECT distinct_id,gameTypeId,-sum(amount)AS amount
   FROM events
   WHERE event = 'addDiamond'
     AND amount <0
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 2 DESC