CREATE DATABASE IF NOT EXISTS daily_mngr CHARACTER SET UTF8 COLLATE utf8_general_ci ;

SELECT sum(count) as sum_count FROM outgoings where day = '2019-04-09';