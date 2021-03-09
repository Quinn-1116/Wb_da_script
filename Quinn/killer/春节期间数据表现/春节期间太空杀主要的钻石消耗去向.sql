SELECT t1.*
FROM
  (SELECT t0.*,
          row_number()over(partition BY t0.date
                           ORDER BY t0.amount DESC)AS amount_rank
   FROM
     (SELECT t2.date,t2.reason_diamond,-sum(t2.amount)AS amount
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN '2021-02-04' AND '2021-02-17'
         GROUP BY 1,
                  2) t1
      JOIN
        (SELECT date,distinct_id,
                     reason_diamond,
                     sum(amount)AS amount
         FROM events
         WHERE event = 'addDiamond'
           AND amount<0
           AND date BETWEEN '2021-02-04' AND '2021-02-17'
         GROUP BY 1,
                  2,
                  3)t2 ON t1.date = t2.date
      AND t1.distinct_id = t2.distinct_id
      GROUP BY 1 ,
               2)t0)t1
WHERE t1.amount_rank <=10
ORDER BY t1.date,t1.amount DESC