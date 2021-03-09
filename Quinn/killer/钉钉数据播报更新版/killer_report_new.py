# coding: utf-8
import pandas as pd

pd.set_option('display.max_columns', 1000)
pd.set_option('display.width', 1000)
pd.set_option('display.max_colwidth', 1000)
import numpy as np
from ssql import ssql
import sys

# game_dnu、game_dau、game_dou
df_gameActive = ssql("""
SELECT t10.date,
       t10.game_dau,
       (t10.game_dau-t10.yesterday_dau)/t10.yesterday_dau AS dau_day,
       (t10.game_dau-t10.last_week_dau)/t10.last_week_dau AS dau_week,

       t10.game_dnu,
       (t10.game_dnu-t10.yesterday_dnu)/t10.yesterday_dnu AS dnu_day,
       (t10.game_dnu-t10.last_week_dnu)/t10.last_week_dnu AS dnu_week,

       t10.game_dou,
       (t10.game_dou-t10.yesterday_dou)/t10.yesterday_dou AS dou_day,
       (t10.game_dou-t10.last_week_dou)/t10.last_week_dou AS dou_week
FROM
  (SELECT t0.date,
          t0.game_dau,
          lead(t0.game_dau,1)over(
                                  ORDER BY t0.date DESC)AS yesterday_dau,
          lead(t0.game_dau,7)over(
                                  ORDER BY t0.date DESC) AS last_week_dau,
          t0.game_dnu,
          lead(t0.game_dnu,1)over(
                                  ORDER BY t0.date DESC) AS yesterday_dnu,
          lead(t0.game_dnu,7)over(
                                  ORDER BY t0.date DESC) AS last_week_dnu,
          t0.game_dou,
          lead(t0.game_dou,1)over(
                                  ORDER BY t0.date DESC) AS yesterday_dou,
          lead(t0.game_dou,7)over(
                                  ORDER BY t0.date DESC) AS last_week_dou
   FROM
     (SELECT t1.date,
             t1.game_dnu,
             t2.game_dau,
             (t2.game_dau-t1.game_dnu)AS game_dou
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS game_dnu--新用户

         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1) t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id)AS game_dau--日活用户

         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t0 LIMIT 1) t10
""")
print("游戏活跃用户数数据已准备")

df_gameRateAll = ssql("""
SELECT t5.date,
       t5.game_dnu,
       t5.`注册-游戏转化率` as regist_to_gameRate,
       (t5.game_dnu-t5.yesterday_game_dnu)/t5.yesterday_game_dnu AS game_dnu_1,
       (t5.game_dnu-t5.last_week_game_dnu)/t5.last_week_game_dnu AS game_dnu_7,
       t5.`注册-游戏转化率`-yesterday_game_rate AS game_rate_1,
       t5.`注册-游戏转化率`-last_week_game_rate AS game_rate_7
FROM
  (SELECT t4.*,
          lead(t4.dnu,1)over(
                             ORDER BY t4.date DESC) AS yesterday_game_dnu,
          lead(t4.dnu,7)over(
                             ORDER BY t4.date DESC) AS last_week_game_dnu,
          lead(t4.`注册-游戏转化率`,1)over(
                                    ORDER BY t4.date DESC) AS yesterday_game_rate,
          lead(t4.`注册-游戏转化率`,7)over(
                                    ORDER BY t4.date DESC) AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t1.distinct_id) AS dnu,
             count(t2.distinct_id) AS login_dnu,
             count(t2.distinct_id)/count(t1.distinct_id) AS `注册-登录转化率`,
             count(t3.distinct_id) AS game_dnu,
             count(t3.distinct_id)/count(t1.distinct_id)AS `注册-游戏转化率`
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id = t2.distinct_id
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id
      GROUP BY 1)t4 LIMIT 1) t5
""")
print("双端游戏率数据已准备")

df_gameRateAndroid = ssql("""
SELECT t5.date,
       t5.game_dnu,
       t5.`注册-游戏转化率` as android_dnu_gamerate,
       (t5.game_dnu-t5.yesterday_game_dnu)/t5.yesterday_game_dnu AS game_dnu_1,
       (t5.game_dnu-t5.last_week_game_dnu)/t5.last_week_game_dnu AS game_dnu_7,
       t5.`注册-游戏转化率`-yesterday_game_rate AS game_rate_1,
       t5.`注册-游戏转化率`-last_week_game_rate AS game_rate_7
FROM
  (SELECT t4.*,
          lead(t4.dnu,1)over(
                             ORDER BY t4.date DESC) AS yesterday_game_dnu,
          lead(t4.dnu,7)over(
                             ORDER BY t4.date DESC) AS last_week_game_dnu,
          lead(t4.`注册-游戏转化率`,1)over(
                                    ORDER BY t4.date DESC) AS yesterday_game_rate,
          lead(t4.`注册-游戏转化率`,7)over(
                                    ORDER BY t4.date DESC) AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t1.distinct_id) AS dnu,
             count(t2.distinct_id) AS login_dnu,
             count(t2.distinct_id)/count(t1.distinct_id) AS `注册-登录转化率`,
             count(t3.distinct_id) AS game_dnu,
             count(t3.distinct_id)/count(t1.distinct_id)AS `注册-游戏转化率`
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id = t2.distinct_id
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id
      GROUP BY 1)t4 LIMIT 1) t5
""")
print("安卓游戏率数据已准备")

df_gameRateIos = ssql("""
SELECT t5.date,
       t5.game_dnu,
       t5.`注册-游戏转化率` AS ios_dnu_gamerate,
       (t5.game_dnu-t5.yesterday_game_dnu)/t5.yesterday_game_dnu AS game_dnu_1,
       (t5.game_dnu-t5.last_week_game_dnu)/t5.last_week_game_dnu AS game_dnu_7,
       t5.`注册-游戏转化率`-yesterday_game_rate AS game_rate_1,
       t5.`注册-游戏转化率`-last_week_game_rate AS game_rate_7
FROM
  (SELECT t4.*,
          lead(t4.dnu,1)over(
                             ORDER BY t4.date DESC) AS yesterday_game_dnu,
          lead(t4.dnu,7)over(
                             ORDER BY t4.date DESC) AS last_week_game_dnu,
          lead(t4.`注册-游戏转化率`,1)over(
                                    ORDER BY t4.date DESC) AS yesterday_game_rate,
          lead(t4.`注册-游戏转化率`,7)over(
                                    ORDER BY t4.date DESC) AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t1.distinct_id) AS dnu,
             count(t2.distinct_id) AS login_dnu,
             count(t2.distinct_id)/count(t1.distinct_id) AS `注册-登录转化率`,
             count(t3.distinct_id) AS game_dnu,
             count(t3.distinct_id)/count(t1.distinct_id)AS `注册-游戏转化率`
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id = t2.distinct_id
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id
      GROUP BY 1)t4 LIMIT 1) t5
""")
print("ios游戏率数据已准备")

df_appActive = ssql("""
SELECT t4.date,
       t4.app_dau,
       t4.app_dnu,
       t4.app_dou,
       (t4.app_dau-t4.yesterday_app_dau)/t4.yesterday_app_dau AS app_dau_rate_1,
       (t4.app_dau- t4.last_week_app_dau)/t4.last_week_app_dau AS app_dau_rate_7,
       (t4.app_dnu - t4.yesterday_app_dnu)/t4.yesterday_app_dnu AS app_dnu_rate_1,
       (t4.app_dnu - t4.last_week_app_dnu)/t4.last_week_app_dnu AS app_dnu_rate_7,
       (t4.app_dou - t4.yesterday_app_dou)/t4.yesterday_app_dou AS app_dou_rate_1,
       (t4.app_dou - t4.last_week_app_dou)/t4.last_week_app_dou AS app_dou_rate_7
FROM
  (SELECT t3.* ,
          lead(t3.app_dau,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dau,
          lead(t3.app_dau,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dau,
          lead(t3.app_dnu,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dnu,
          lead(t3.app_dnu,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dnu,
          lead(t3.app_dou,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dou,
          lead(t3.app_dou,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dou
   FROM
     (SELECT t1.date,
             t1.app_dnu,
             t2.app_dau,
             (t2.app_dau-t1.app_dnu)AS app_dou
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS app_dnu--新用户

         FROM events
         WHERE event = 'register'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1) t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id)AS app_dau--日活用户

         FROM events
         WHERE event = 'login'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4
""")
print("双端活跃数据已准备")

df_appActiveAndroid = ssql("""
SELECT t4.date, t4.app_dau,
                t4.app_dnu,
                t4.app_dou,
                (t4.app_dau-t4.yesterday_app_dau)/t4.yesterday_app_dau AS app_dau_rate_1,
                (t4.app_dau- t4.last_week_app_dau)/t4.last_week_app_dau AS app_dau_rate_7,
                (t4.app_dnu - t4.yesterday_app_dnu)/t4.yesterday_app_dnu AS app_dnu_rate_1,
                (t4.app_dnu - t4.last_week_app_dnu)/t4.last_week_app_dnu AS app_dnu_rate_7,
                (t4.app_dou - t4.yesterday_app_dou)/t4.yesterday_app_dou AS app_dou_rate_1,
                (t4.app_dou - t4.last_week_app_dou)/t4.last_week_app_dou AS app_dou_rate_7
FROM
  (SELECT t3.* ,
          lead(t3.app_dau,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dau,
          lead(t3.app_dau,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dau,
          lead(t3.app_dnu,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dnu,
          lead(t3.app_dnu,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dnu,
          lead(t3.app_dou,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dou,
          lead(t3.app_dou,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dou
   FROM
     (SELECT t1.date, t1.app_dnu,
                      t2.app_dau,
                      (t2.app_dau-t1.app_dnu)AS app_dou
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS app_dnu--新用户

         FROM events
         WHERE event = 'register'
           AND appId IN ('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1) t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id)AS app_dau--日活用户

         FROM events
         WHERE event = 'login'
           AND appId IN ('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4
""")
print("安卓活跃数据已准备")

df_appActiveIos = ssql("""
SELECT t4.date, t4.app_dau,
                t4.app_dnu,
                t4.app_dou,
                (t4.app_dau-t4.yesterday_app_dau)/t4.yesterday_app_dau AS app_dau_rate_1,
                (t4.app_dau- t4.last_week_app_dau)/t4.last_week_app_dau AS app_dau_rate_7,
                (t4.app_dnu - t4.yesterday_app_dnu)/t4.yesterday_app_dnu AS app_dnu_rate_1,
                (t4.app_dnu - t4.last_week_app_dnu)/t4.last_week_app_dnu AS app_dnu_rate_7,
                (t4.app_dou - t4.yesterday_app_dou)/t4.yesterday_app_dou AS app_dnu_rate_1,
                (t4.app_dou - t4.last_week_app_dou)/t4.last_week_app_dou AS app_dnu_rate_7
FROM
  (SELECT t3.* ,
          lead(t3.app_dau,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dau,
          lead(t3.app_dau,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dau,
          lead(t3.app_dnu,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dnu,
          lead(t3.app_dnu,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dnu,
          lead(t3.app_dou,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dou,
          lead(t3.app_dou,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dou
   FROM
     (SELECT t1.date, t1.app_dnu,
                      t2.app_dau,
                      (t2.app_dau-t1.app_dnu)AS app_dou
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS app_dnu--新用户

         FROM events
         WHERE event = 'register'
           AND appId IN ('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1) t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id)AS app_dau--日活用户

         FROM events
         WHERE event = 'login'
           AND appId IN ('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4
""")
print("ios活跃数据已准备")

df_pay = ssql("""SELECT t4.date,
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
           AND appId in('20014', '30015','20009')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id) AS `付费人数`,
                     sum(pay)AS `付费金额`,
                     sum(pay)/count(DISTINCT distinct_id) AS arppu
         FROM events
         WHERE event = 'pay'
           AND appId in('20014','30015','20009')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4""")
print("双端付费数据已准备")

df_payAndroid = ssql("""
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
""")
print("安卓付费数据已准备")

df_payIos = ssql("""
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
""")
print("ios付费数据已准备")

# 游戏新用户次留、七留数据
df_gameRetention = ssql("""
SELECT t10.date,
       t10.game_new_user_r1,
       t10.game_new_user_r1-t10.day_game_rate AS day_game_rate,
       t10.game_new_user_r1-t10.last_week_game_rate AS week_game_rate
FROM
  (SELECT t0.date,
          t0.game_new_user_r1,
          lead(t0.game_new_user_r1,1)over(
                                          ORDER BY t0.date DESC)AS day_game_rate,
          lead(t0.game_new_user_r1,7)over(
                                          ORDER BY t0.date DESC)AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t2.distinct_id)/count(t1.distinct_id) game_new_user_r1
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 9 DAY AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2) t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND datediff(t2.date,t1.date) = 1
      GROUP BY 1)t0 LIMIT 1)t10
""")
print("游戏新用户次留、七留数据已准备")

# 人均游戏局数
df_avg_game = ssql("""
SELECT sum(game_num)/count(distinct_id)as avg_gameTime
FROM
  (SELECT distinct_id,
          count(distinct_id)AS game_num
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date = current_date() - interval 1 DAY
   GROUP BY 1)t1""")
print("人均游戏局数已准备")

# 人均游戏时长
df_avg_duration = ssql("""
SELECT sum(duration)/count(distinct_id)as avg_gameDuration
FROM
  (SELECT distinct_id,
          sum(duration/60000)AS duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date = current_date() - interval 1 DAY
   GROUP BY 1)t1""")
print("人均游戏时长数据已准备")

# 单局平均时长
df_game_avg_durantion = ssql("""SELECT sum(duration)/count(match_id)as avg_singleGameDuration
FROM
  (SELECT match_id,
          (duration/60000) AS duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date = current_date() - interval 1 DAY
   GROUP BY 1,
            2)t1""")
print("单局平均时长数据已准备")

# 双端新用户次留
df_app_retention = ssql("""

SELECT t4.r1,
       t4.yesterday_r1,
       t4.lastweek_r1,
       t4.r1 - t4.yesterday_r1 AS yesterday_r1 ,
       t4.r1 - t4.lastweek_r1 AS lastweek_r1
FROM
  (SELECT t3.*,
          lead(t3.r1,1)over(
                            ORDER BY t3.date DESC) AS yesterday_r1,
          lead(t3.r1,7)over(
                            ORDER BY t3.date DESC) AS lastweek_r1
   FROM
     (SELECT t1.date,
             count(t1.distinct_id)AS register_num,
             count(t2.distinct_id)AS remain_num,
             count(t2.distinct_id)/count(t1.distinct_id) AS r1
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('30015','20014')
           AND date BETWEEN current_date() - interval 9 DAY AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('30015','20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND datediff(t2.date,t1.date) = 1
      GROUP BY 1)t3 LIMIT 1)t4
""")
print("双端新用户次留数据已准备")


def per_tf(x):
    return '%.1f%%' % (x * 100)


def compare(Df, col):
    if Df.loc[0, '{}'.format(col)] > 0:
        return "↑ " + per_tf(Df.loc[0, '{}'.format(col)])
    else:
        return "↓ " + per_tf(np.abs(Df.loc[0, '{}'.format(col)]))


mark_down_data = '''
**{date_1}数据简报**  
**<font color="#dd0000">双端活跃</font>**  
双端DAU:{app_dau}, 环比昨日{app_dau_2}, 同比上周{app_dau_7}  
双端DNU:{app_dnu}, 环比昨日{app_dnu_2}, 同比上周{app_dnu_7}  
DNU游戏率{new_user_gameRate}, 环比昨日{new_user_gameRate_1}, 同比上周{new_user_gameRate_7}  
前一日新用户次留:{dnu_r1}, 环比上一日{dnu_r2}, 同比上周{dnu_r7}  
**<font color="#dd0000">双端游戏</font>**  
游戏DAU:{game_dau}, 环比昨日{dau_2}, 同比上周{dau_7}  
游戏DNU:{game_dnu}, 环比昨日{dnu_2}, 同比上周{dnu_7}  
前一日游戏新用户次留:{game_dnu_r1}, 环比昨日{game_dnu_r2}, 同比上周{game_dnu_r7}  
人均游戏时长:{avg_gameDuration}  
人均游戏局数:{avg_gameTime}  
单局平均时长:{avg_singleGameDuration}  
**<font color="#dd0000">双端付费</font>**  
付费金额:{app_pay_sum}, 环比昨日{app_pay_sum_1}, 同比上周{app_pay_sum_7}  
付费人数:{app_pay_num}, 环比昨日{app_pay_num_1}, 同比上周{app_pay_num_7}  
付费率:{app_pay_rate}  
arpu:{app_arpu}  
arppu:{app_arppu}  
**<font color="#dd0000">安卓端数据</font>**  
安卓DAU:{android_dau}, 环比昨日{android_dau_2}, 同比上周{android_dau_7}  
安卓DNU:{android_dnu}, 环比昨日{android_dnu_2}, 同比上周{android_dnu_7}  
DNU游戏率{android_new_user_gameRate}, 环比昨日{android_new_user_gameRate_1}, 同比上周{android_new_user_gameRate_7}  
付费金额:{android_pay_sum}, 环比昨日{android_pay_sum_1}, 同比上周{android_pay_sum_7}  
付费人数:{android_pay_num}, 环比昨日{android_pay_num_1}, 同比上周{android_pay_num_7}  
付费率:{android_pay_rate}  
arpu:{android_arpu}  
arppu:{android_arppu}  
**<font color="#dd0000">ios端数据</font>**  
ios-DAU:{ios_dau}, 环比昨日{ios_dau_2}, 同比上周{ios_dau_7}  
ios-DNU:{ios_dnu}, 环比昨日{ios_dnu_2}, 同比上周{ios_dnu_7}  
DNU游戏率{ios_new_user_gameRate}, 环比昨日{ios_new_user_gameRate_1}, 同比上周{ios_new_user_gameRate_7}  
付费金额:{ios_pay_sum}, 环比昨日{ios_pay_sum_1}, 同比上周{ios_pay_sum_7}  
付费人数:{ios_pay_num}, 环比昨日{ios_pay_num_1}, 同比上周{ios_pay_num_7}  
付费率:{ios_pay_rate}  
arpu:{ios_arpu}  
arppu:{ios_arppu}
'''

markdown_file = mark_down_data.format(
    date_1=str(df_gameActive.loc[0, 'date']),
    # 双端数据
    # 双端活跃
    app_dau=str(df_appActive.loc[0, 'app_dau']), app_dau_2=compare(df_appActive, 'app_dau_rate_1'),# 双端DAU
    app_dau_7=compare(df_appActive, 'app_dau_rate_7'),  # 双端日活, 同环比
    app_dnu=str(df_appActive.loc[0, 'app_dnu']), app_dnu_2=compare(df_appActive, 'app_dnu_rate_1'), # 双端DNU
    app_dnu_7=compare(df_appActive, 'app_dnu_rate_7'),  # 双端新增, 同环比
    # dnu_gameNum=str(df_gameRateAll.loc[0, 'game_dnu']), # 双端游戏DNU
    new_user_gameRate=str(per_tf(df_gameRateAll.loc[0, 'regist_to_gamerate'])), # 双端新用户游戏率
    new_user_gameRate_1=compare(df_gameRateAll, 'game_rate_1'), # 双端新用户游戏率环比昨日
    new_user_gameRate_7=compare(df_gameRateAll, 'game_rate_7'),  # 双端新用户游戏率同比上周
    dnu_r1=str(per_tf(df_app_retention.loc[0, 'r1'])), dnu_r2=compare(df_app_retention, 'yesterday_r1'), #
    dnu_r7=compare(df_app_retention, 'lastweek_r1'),  # 双端的次留
    # 双端游戏
    game_dau=str(df_gameActive.loc[0, 'game_dau']), dau_2=compare(df_gameActive, 'dau_day'),
    dau_7=compare(df_gameActive, 'dau_week'),  # 游戏DAU 同环比
    game_dnu=str(df_gameActive.loc[0, 'game_dnu']), dnu_2=compare(df_gameActive, 'dnu_day'),
    dnu_7=compare(df_gameActive, 'dnu_week'),  # 游戏DNU 同环比
    game_dnu_r1=str(per_tf(df_gameRetention.loc[0, 'game_new_user_r1'])),
    game_dnu_r2=compare(df_gameRetention, 'day_game_rate'), game_dnu_r7=compare(df_gameRetention, 'week_game_rate'),
    # 游戏新用户的次留 同环比
    avg_gameDuration=str(np.round(df_avg_duration.values[0][0],2)) + "分钟", avg_gameTime=str(np.round(df_avg_game.values[0][0],2)) + "局",
    avg_singleGameDuration=str(np.round(df_game_avg_durantion.values[0][0],2)) + "分钟",  # 平均游戏时长、平均游戏局数、单局平均时长
    # 双端付费
    app_pay_sum = "¥" + str(df_pay.loc[0, 'paysum']), app_pay_sum_1=compare(df_pay, 'paysum_1'),
    app_pay_sum_7=compare(df_pay, 'paysum_7'),  # 付费金额，同环比
    app_pay_num=str(df_pay.loc[0, 'paynum']), app_pay_num_1=compare(df_pay, 'paynum_1'),
    app_pay_num_7=compare(df_pay, 'paynum_7'),  # 付费人数，同环比
    app_pay_rate=str(per_tf(df_pay.loc[0, 'payrate'])),  # 付费率
    app_arpu = "¥" + str(np.round(df_pay.loc[0, 'arpu'],2)), app_arppu = "¥" + str(np.round(df_pay.loc[0, 'arppu'],2)),  # arpu、arppu
    # 安卓端数据
    android_dau=str(df_appActiveAndroid.loc[0, 'app_dau']), # 安卓DAU
    android_dau_2=compare(df_appActiveAndroid, 'app_dau_rate_1'), # 安卓DAU环比昨日
    android_dau_7=compare(df_appActiveAndroid, 'app_dau_rate_7'),  # 安卓端DAU同比上周
    android_dnu=str(df_appActiveAndroid.loc[0, 'app_dnu']), # 安卓DNU
    android_dnu_2=compare(df_appActiveAndroid, 'app_dnu_rate_1'), # 安卓DNU环比昨日
    android_dnu_7=compare(df_appActiveAndroid, 'app_dnu_rate_7'),  # 安卓DNU同比上周
    # android_dnu_gameNum=str(df_gameRateAndroid.loc[0, 'game_dnu']), # 安卓游戏新用户数
    android_new_user_gameRate=str(per_tf(df_gameRateAndroid.loc[0, 'android_dnu_gamerate'])),# 安卓新用户当日游戏率
    android_new_user_gameRate_1=compare(df_gameRateAndroid, 'game_rate_1'), # 安卓新用户游戏率环比昨日
    android_new_user_gameRate_7=compare(df_gameRateAndroid, 'game_rate_7'),  # 安卓新用户游戏率同比上周
    android_pay_sum= "¥"+str(df_payAndroid.loc[0, 'paysum']), android_pay_sum_1=compare(df_payAndroid, 'paysum_1'),
    android_pay_sum_7=compare(df_payAndroid, 'paysum_7'),  # 安卓付费金额，同环比
    android_pay_num=str(df_payAndroid.loc[0, 'paynum']), android_pay_num_1=compare(df_payAndroid, 'paynum_1'),
    android_pay_num_7=compare(df_payAndroid, 'paynum_7'),  # 安卓付费人数，同环比
    android_pay_rate=str(per_tf(df_payAndroid.loc[0, 'payrate'])),  # 付费率
    android_arpu = "¥" + str(np.round(df_payAndroid.loc[0, 'arpu'],2)),
    android_arppu = "¥" + str(np.round(df_payAndroid.loc[0, 'arppu'],2)),
    # ios端数据
    ios_dau=str(df_appActiveIos.loc[0, 'app_dau']), ios_dau_2=compare(df_appActiveIos, 'app_dau_rate_1'),
    ios_dau_7=compare(df_appActiveIos, 'app_dau_rate_7'),  # ios端日活，同环比
    ios_dnu=str(df_appActiveIos.loc[0, 'app_dnu']), ios_dnu_2=compare(df_appActiveIos, 'app_dnu_rate_1'),
    ios_dnu_7=compare(df_appActiveIos, 'app_dnu_rate_7'),  # ios端新增，同环比
    # ios_dnu_gameNum=str(df_gameRateIos.loc[0, 'game_dnu']), # ios新增游戏用户数
    ios_new_user_gameRate=str(per_tf(df_gameRateIos.loc[0, 'ios_dnu_gamerate'])), # ios新用户游戏率
    ios_new_user_gameRate_1=compare(df_gameRateIos, 'game_rate_1'),# ios游戏率环比昨日
    ios_new_user_gameRate_7=compare(df_gameRateIos, 'game_rate_7'),  # ios端新增游戏用户数,游戏率，游戏率的同环比
    ios_pay_sum= "¥" + str(df_payIos.loc[0, 'paysum']), ios_pay_sum_1=compare(df_payIos, 'paysum_1'),
    ios_pay_sum_7 = compare(df_payIos, 'paysum_7'),  # ios付费金额，同环比
    ios_pay_num = str(df_payIos.loc[0, 'paynum']), ios_pay_num_1=compare(df_payIos, 'paynum_1'),
    ios_pay_num_7 = compare(df_payIos, 'paynum_7'),  # ios付费人数，同环比
    ios_pay_rate = str(per_tf(df_payIos.loc[0, 'payrate'])),  # ios付费率
    ios_arpu="¥" + str(np.round(df_payIos.loc[0, 'arpu'],2)),  # ios arpu
    ios_arppu = "¥" + str(np.round(df_payIos.loc[0, 'arppu'],2))  # iOS arppu

)

from dingtalkchatbot.chatbot import DingtalkChatbot
# killer群
webhook = "https://oapi.dingtalk.com/robot/send?access_token=5c0ba0fd48989b39e6f696ddfe79f109fb04aabca6470658672175492457d525"
secret = "SEC53943bfd7039ee1990c42fa78d46b5701d63b5da0998a6fc16a0007e9ddeee9b"

# # 测试群
#webhook = "https://oapi.dingtalk.com/robot/send?access_token=2606c23eaf70851235a10785081a8fedcc72d210c9379c9b960c32d571372b8a"
#secret = "SEC2fe3fce80cc0a5b2de41423c540b8f58c2f2c393a7c2ec28c75d9bdd0062939e"
xiaoding = DingtalkChatbot(webhook, secret=secret)
xiaoding.send_markdown(title='太空杀数据播报', text=markdown_file, is_at_all=True)
print("播报已发送")
