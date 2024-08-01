--use [sql]
--CREATE TABLE users ( USER_ID INT PRIMARY KEY, USER_NAME VARCHAR(20) NOT NULL, USER_STATUS VARCHAR(20) NOT NULL ); 
--CREATE TABLE logins ( USER_ID INT, LOGIN_TIMESTAMP DATETIME NOT NULL, SESSION_ID INT PRIMARY KEY, SESSION_SCORE INT, FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID) ); 
--INSERT INTO USERS VALUES (1, 'Alice', 'Active'),(2, 'Bob', 'Inactive'),(3, 'Charlie', 'Active'),(4, 'David', 'Active'),(5, 'Eve', 'Inactive'),(6, 'Frank', 'Active'),(7, 'Grace', 'Inactive'),(8, 'Heidi', 'Active'),(9, 'Ivan', 'Inactive'),(10, 'Judy', 'Active');
--INSERT INTO LOGINS VALUES (1, '2023-07-15 09:30:00', 1001, 85);
---INSERT INTO LOGINS VALUES (2, '2023-07-22 10:00:00', 1002, 90);
---INSERT INTO LOGINS VALUES (3, '2023-08-10 11:15:00', 1003, 75); INSERT INTO LOGINS VALUES (4, '2023-08-20 14:00:00', 1004, 88); INSERT INTO LOGINS VALUES (5, '2023-09-05 16:45:00', 1005, 82); INSERT INTO LOGINS VALUES (6, '2023-10-12 08:30:00', 1006, 77); INSERT INTO LOGINS VALUES (7, '2023-11-18 09:00:00', 1007, 81); INSERT INTO LOGINS VALUES (8, '2023-12-01 10:30:00', 1008, 84); INSERT INTO LOGINS VALUES (9, '2023-12-15 13:15:00', 1009, 79);
--INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1011, 86); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2024-01-25 09:30:00', 1012, 89); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-02-05 11:00:00', 1013, 78); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2024-03-01 14:30:00', 1014, 91); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-03-15 16:00:00', 1015, 83); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2024-04-12 08:00:00', 1016, 80); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (7, '2024-05-18 09:15:00', 1017, 82); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (8, '2024-05-28 10:45:00', 1018, 87); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (9, '2024-06-15 13:30:00', 1019, 76); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-25 15:00:00', 1010, 92); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-26 15:45:00', 1020, 93); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-27 15:00:00', 1021, 92); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (10, '2024-06-28 15:45:00', 1022, 93); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (1, '2024-01-10 07:45:00', 1101, 86); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (3, '2024-01-25 09:30:00', 1102, 89); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (5, '2024-01-15 11:00:00', 1103, 78); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (2, '2023-11-10 07:45:00', 1201, 82); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (4, '2023-11-25 09:30:00', 1202, 84); INSERT INTO LOGINS (USER_ID, LOGIN_TIMESTAMP, SESSION_ID, SESSION_SCORE) VALUES (6, '2023-11-15 11:00:00', 1203, 80);

--select * from logins; 
--select * from users;
--1. Management wants to know who did not login for last 5 months 
select user_id, max(login_timestamp) as last_login
from logins group by user_id 
having max(login_timestamp) < DATEADD(month,-5,getdate())
--2.How many sessions,users at each quarter (return , quarter , first day of quarter , no of sessions , no of users in quarter)
select DATEPART(QUARTER,login_timestamp) as quarter ,
Dateadd(Quarter,DATEDIFF(quarter,0,min(LOGIN_TIMESTAMP)),0) as First_day,
count(user_id) as no_of_sessions,
count( distinct user_id) as no_of_users,
min(login_timestamp) as first_login_on
from logins
group by DATEPART(QUARTER,login_timestamp);
--------------------------------------------------------------------------------------------------------------------------
--3. Select a user_id where he logged in january 2024 and not logged in november 2023
select distinct user_id from logins where login_timestamp between '2024-01-01' and '2024-01-31'
except
select user_id from logins where LOGIN_TIMESTAMP between '2023-11-01' and '2023-11-30'

--------------------------------------------------------------------------------------------------------------------------
--4.From Query NO.2 add percentage change in sessions from last column 
-- Return : first_day_of_Quarter ,session_cnt , prev_session , session_change_percentage_change

with cte as (select DATEPART(QUARTER,login_timestamp) as quarter ,
			Dateadd(Quarter,DATEDIFF(quarter,0,min(LOGIN_TIMESTAMP)),0) as First_day,
			count(user_id) as session_cnt,
			lag(count(user_id)) over(order by DATEPART(QUARTER,login_timestamp)) as lagi,
			min(login_timestamp) as first_login_on
			from logins
			group by DATEPART(QUARTER,login_timestamp))

select First_day,session_cnt,lagi as prev_session,round(cast((session_cnt-lagi)*100.0/session_cnt as float) ,2) as percentage_change_of_session from cte

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--5.Display the User that has highest session_score for each day 
--Return : Date , user_Name,score

select cast(LOGIN_TIMESTAMP as date) as Date, s.USER_NAME ,max(SESSION_SCORE) as Highest_session_score from 
Users s join logins l
on s.user_id = l.user_id 
group by cast(LOGIN_TIMESTAMP as date),s.USER_NAME  order by Date

-- 6. To Identify best users 
-- Return the Users that had a session in every single possible date
select USER_ID,min(cast(login_timestamp as date )) as First_login,
               max(cast(login_timestamp as date )) as Last_Login,
			   datediff(day,min(cast(login_timestamp as date )),GETDATE())+1 as date,
			   count(distinct cast(login_timestamp as date )) as no_of_logins
from logins
group by USER_ID
order by no_of_logins desc;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7. Find all login dates where there are no logins
--Return login dates

select max(LOGIN_TIMESTAMP),min(LOGIN_TIMESTAMP) from logins 
with cte as (
select cast('2023-07-15 09:30:00.000' as date) as date1 
union all
select DATEADD(day,1,date1) from cte where date1 <'2024-06-28'
)
--select * from cte option(maxrecursion 500);

select date1 from cte  where date1 not in (select cast(LOGIN_TIMESTAMP as date) from logins )option(maxrecursion 500)



------------------------------------------------------------------------------------------------------------------------------

