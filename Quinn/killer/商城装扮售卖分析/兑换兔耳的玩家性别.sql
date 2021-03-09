
SELECT t2.reg_gender,
       count(t2.second_id)
FROM
  (SELECT date, distinct_id,
                goods_name ,
                amount,
                time
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND goods_name IN('加勒比船长','航海王')
     AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
     AND date BETWEEN '2020-11-28' AND '2020-12-18'
   GROUP BY 1,
            2,
            3,
            4,
            5) t1
LEFT JOIN
  (SELECT second_id,
          FROM_UNIXTIME(CAST($signup_time/1000 AS BIGINT))AS "注册时间",
          reg_gender
   FROM users
   WHERE second_id IS NOT NULL)t2 ON t1.distinct_id = t2.second_id
GROUP BY 1