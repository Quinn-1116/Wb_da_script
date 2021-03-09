--首次消耗钻石量分布

SELECT t3.amount,
       count(t3.distinct_id)
FROM
  (SELECT t2.*
   FROM
     (SELECT distinct_id,
             amount,
             row_number()over(partition BY distinct_id
                              ORDER BY time)AS time_rank
      FROM
        (SELECT date, distinct_id,
                      goods_name AS `装扮名称`,
                      amount,
                      time
         FROM events
         WHERE event = 'exchange'
           AND currency_type = 'diamond'
           AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
           AND date BETWEEN '2020-11-28' AND '2020-12-18'
         GROUP BY 1,
                  2,
                  3,
                  4,
                  5
         UNION SELECT date, distinct_id,
                            CASE WHEN goods_name = 'killer_hat_hellowhair' THEN '时尚金发' WHEN goods_name = 'killer_hat_crown' THEN '小皇冠' WHEN goods_name = 'killer_hat_aperture' THEN '天使光环' WHEN goods_name = 'killer_dress_adventure' THEN '探险装' WHEN goods_name = 'killer_hat_flower' THEN '花盆' END AS "装扮名称",
amount,
time
         FROM events
WHERE event = 'exchange'
AND currency_type = 'diamond'
AND goods_name LIKE '%killer%'
AND date BETWEEN '2020-10-31' AND '2020-11-27'
         GROUP BY 1,
                  2,
                  3,
                  4,
                  5) t1)t2
WHERE t2.time_rank = 1)t3
GROUP BY 1
ORDER BY 1 DESC