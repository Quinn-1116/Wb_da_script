--付费人数、付费金额、arpu（每用户平均收入）、arppu（每付费用户平均收入）、付费率（付费用户数/dau）

SELECT t4.date,
       t4.payNum,
       t4.paySum,
       t4.payRate,
       t4.arpu,
       t4.arppu,
       (t4.payNum-t4.yesterday_payNum)/t4.yesterday_payNum AS payNum_1,
       (t4.payNum-t4.lastweek_payNum)/t4.lastweek_payNum AS payNum_7,
       (t4.paySum - t4.yesterday_paySum)/t4.yesterday_paySum AS paySum_1,
       (t4.paySum - t4.lastweek_paySum)/t4.lastweek_paySum AS paySum_7
FROM
  (SELECT t3.*,
          lead(t3.payNum,1)over(
                                ORDER BY t3.date DESC) AS yesterday_payNum,
          lead(t3.payNum,7)over(
                                ORDER BY t3.date DESC) AS lastweek_payNum,
          lead(t3.paySum,1)over(
                                ORDER BY t3.date DESC) AS yesterday_paySum,
          lead(t3.paySum,7)over(
                                ORDER BY t3.date DESC) AS lastweek_paySum,
          lead(t3.payRate,1)over(
                                 ORDER BY t3.date DESC) AS yesterday_payRate,
          lead(t3.payRate,7)over(
                                 ORDER BY t3.date DESC) AS lastweek_payRate,
          lead(t3.arpu,1)over(
                              ORDER BY t3.date DESC) AS yesterday_arpu,
          lead(t3.arpu,7)over(
                              ORDER BY t3.date DESC) AS lastweek_arpu,
          lead(t3.arppu,1)over(
                               ORDER BY t3.date DESC) AS yesterday_arppu,
          lead(t3.arppu,7)over(
                               ORDER BY t3.date DESC) AS lastweek_arppu
   FROM
     (SELECT t1.date,
             t2.`付费人数`AS payNum,
             t2.`付费金额` AS paySum,
             t2.`付费人数`/t1.`活跃用户数`AS payRate,
             t2.`付费金额`/t1.`活跃用户数` AS arpu,
             t2.arppu
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS `活跃用户数`
         FROM events
         WHERE event = 'login'
           AND appId in('20014', '30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id) AS `付费人数`,
                     sum(pay)AS `付费金额`,
                     sum(pay)/count(DISTINCT distinct_id) AS arppu
         FROM events
         WHERE event = 'pay'
           AND appId in('20014','30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4



  SELECT t4.date,
       t4.payNum,
       t4.paySum,
       t4.payRate,
       t4.arpu,
       t4.arppu,
       (t4.payNum-t4.yesterday_payNum)/t4.yesterday_payNum AS payNum_1,
       (t4.payNum-t4.lastweek_payNum)/t4.lastweek_payNum AS payNum_7,
       (t4.paySum - t4.yesterday_paySum)/t4.yesterday_paySum AS paySum_1,
       (t4.paySum - t4.lastweek_paySum)/t4.lastweek_paySum AS paySum_7
FROM
  (SELECT t3.*,
          lead(t3.payNum,1)over(
                                ORDER BY t3.date DESC) AS yesterday_payNum,
          lead(t3.payNum,7)over(
                                ORDER BY t3.date DESC) AS lastweek_payNum,
          lead(t3.paySum,1)over(
                                ORDER BY t3.date DESC) AS yesterday_paySum,
          lead(t3.paySum,7)over(
                                ORDER BY t3.date DESC) AS lastweek_paySum,
          lead(t3.payRate,1)over(
                                 ORDER BY t3.date DESC) AS yesterday_payRate,
          lead(t3.payRate,7)over(
                                 ORDER BY t3.date DESC) AS lastweek_payRate,
          lead(t3.arpu,1)over(
                              ORDER BY t3.date DESC) AS yesterday_arpu,
          lead(t3.arpu,7)over(
                              ORDER BY t3.date DESC) AS lastweek_arpu,
          lead(t3.arppu,1)over(
                               ORDER BY t3.date DESC) AS yesterday_arppu,
          lead(t3.arppu,7)over(
                               ORDER BY t3.date DESC) AS lastweek_arppu
   FROM
     (SELECT t1.date,
             t2.`付费人数`AS payNum,
             t2.`付费金额` AS paySum,
             t2.`付费人数`/t1.`活跃用户数`AS payRate,
             t2.`付费金额`/t1.`活跃用户数` AS arpu,
             t2.arppu
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS `活跃用户数`
         FROM events
         WHERE event = 'login'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id) AS `付费人数`,
                     sum(pay)AS `付费金额`,
                     sum(pay)/count(DISTINCT distinct_id) AS arppu
         FROM events
         WHERE event = 'pay'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4




  SELECT t4.date,
       t4.payNum,
       t4.paySum,
       t4.payRate,
       t4.arpu,
       t4.arppu,
       (t4.payNum-t4.yesterday_payNum)/t4.yesterday_payNum AS payNum_1,
       (t4.payNum-t4.lastweek_payNum)/t4.lastweek_payNum AS payNum_7,
       (t4.paySum - t4.yesterday_paySum)/t4.yesterday_paySum AS paySum_1,
       (t4.paySum - t4.lastweek_paySum)/t4.lastweek_paySum AS paySum_7
FROM
  (SELECT t3.*,
          lead(t3.payNum,1)over(
                                ORDER BY t3.date DESC) AS yesterday_payNum,
          lead(t3.payNum,7)over(
                                ORDER BY t3.date DESC) AS lastweek_payNum,
          lead(t3.paySum,1)over(
                                ORDER BY t3.date DESC) AS yesterday_paySum,
          lead(t3.paySum,7)over(
                                ORDER BY t3.date DESC) AS lastweek_paySum,
          lead(t3.payRate,1)over(
                                 ORDER BY t3.date DESC) AS yesterday_payRate,
          lead(t3.payRate,7)over(
                                 ORDER BY t3.date DESC) AS lastweek_payRate,
          lead(t3.arpu,1)over(
                              ORDER BY t3.date DESC) AS yesterday_arpu,
          lead(t3.arpu,7)over(
                              ORDER BY t3.date DESC) AS lastweek_arpu,
          lead(t3.arppu,1)over(
                               ORDER BY t3.date DESC) AS yesterday_arppu,
          lead(t3.arppu,7)over(
                               ORDER BY t3.date DESC) AS lastweek_arppu
   FROM
     (SELECT t1.date,
             t2.`付费人数`AS payNum,
             t2.`付费金额` AS paySum,
             t2.`付费人数`/t1.`活跃用户数`AS payRate,
             t2.`付费金额`/t1.`活跃用户数` AS arpu,
             t2.arppu
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS `活跃用户数`
         FROM events
         WHERE event = 'login'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id) AS `付费人数`,
                     sum(pay)AS `付费金额`,
                     sum(pay)/count(DISTINCT distinct_id) AS arppu
         FROM events
         WHERE event = 'pay'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4