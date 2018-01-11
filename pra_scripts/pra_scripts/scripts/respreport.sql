--Responsibility Wise Settings-----

col responsibility_name format a40 Trunc
col "No.of Users" format 99999
Col "server Name" format a40 trunc
break on "Server Name"
select  profile_option_value "Server Name", responsibility_name ,
(select count(*) from fnd_user_resp_groups m , fnd_user n
where
responsibility_id = a.responsibility_id
and m.user_id = n.user_id
and (n.end_date > sysdate or n.end_date is null) 
and  and Trunc(b.last_logon_date)=trunc(sysdate)) "No.of Users"
 from
 FND_RESPONSIBILITY_VL a, fnd_profile_option_values b
where
b.profile_option_id = 3769
and b.level_id=10003
and b.level_value = a.responsibility_id
order by 1

/




Responsibilities that have  site level settings 


select x.responsibility_name ,
(select count(*) from fnd_user_resp_groups m , fnd_user n 
where 
responsibility_id = x.responsibility_id 
and m.user_id = n.user_id 
and (n.end_date > sysdate or n.end_date is null) ) "No.of Users",
 profile_option_value "Server Name" from
 FND_RESPONSIBILITY_VL a, fnd_profile_option_values b
where
b.profile_option_id = 3769
and b.level_id=1001
and b.level
--and b.level_value = a.responsibility_id
order by 1
---------------------------------------------------------

select b.responsibility_name ,count(a.user_id) no_of_users 
from 
fnd_user_resp_groups  a, fnd_responsibility_vl b
where a.responsibility_id = b.responsibility_id
and user_id in (select user_id from fnd_user where (end_date > sysdate or end_date is null)
)
and responsibility_id not in 
(
select level_value "responsibility_id"  from
fnd_profile_option_values b
where
b.profile_option_id = 3769
and b.level_id=10003
)



group by responsibility_name 
order by 2
/

---------------------------------------
responsibility_id in
(
select responsibility_id from fnd_responsibility_vl where 
end_date is null or end_date > sysdate
minus
select level_value "responsibility_id"  from
fnd_profile_option_values b
where
b.profile_option_id = 3769
and b.level_id=10003
)
--and 2 <> 0
order by 2 




select responsibility_name ,(select count(user_id) from fnd_user_resp_groups m 
where
m.responsibility_id = j.responsibility_id
and user_id in ( select user_id from fnd_user where 
(n.end_date > sysdate or n.end_date is null) ) )"No.of Users"
from fnd_responsibility_vl  j 
where 2 > 0
and end_date is null or end_date > sysdate




select b.responsibility_name , b. responsibility_id , count(a.user_id) no_of_users 
from 
fnd_user_resp_groups  a, fnd_responsibility_vl b
where a.responsibility_id = b.responsibility_id
and user_id in (select user_id from fnd_user where (end_date > sysdate or end_date is null)
)
and a.responsibility_id not in 
(
select level_value "responsibility_id"  from
fnd_profile_option_values b
where
b.profile_option_id = 3769
and b.level_id=10003
)
group by responsibility_name , b.responsibility_id 
order by 3
/






select a.user_id, count(responsibility_id)  from fnd_user_resp_groups a, fnd_user b
 where (a.end_date is null or a.end_date > sysdate)
and Trunc(b.last_logon_date)=trunc(sysdate)
and (b.end_date is null or b.end_date > sysdate)
and a.user_id= b.user_id 
and a.responsibility_id in
(select level_value "responsibility_id"  from
fnd_profile_option_values b
where
b.profile_option_id = 3769
and b.level_id=10003
) 
group by a.user_id 


select a.user_id, count(responsibility_id)  from fnd_user_resp_groups a, fnd_user b
 where (a.end_date is null or a.end_date > sysdate)
and Trunc(b.last_logon_date)=trunc(sysdate)
and (b.end_date is null or b.end_date > sysdate)
and a.user_id= b.user_id 
and a.responsibility_id not in 
(select level_value "responsibility_id"  from
fnd_profile_option_values b
where
b.profile_option_id = 3769
and b.level_id=10003
) 
group by a.user_id 




select count(a.user_id), responsibility_id  from fnd_user_resp_groups a, fnd_user b
  where (a.end_date is null or a.end_date > sysdate)
 and Trunc(b.last_logon_date)=trunc(sysdate)
 and (b.end_date is null or b.end_date > sysdate)
 and a.user_id= b.user_id
 and a.responsibility_id not in
 (select level_value "responsibility_id"  from
 fnd_profile_option_values b
 where
 b.profile_option_id = 3769
 and b.level_id=10003
 )
 group by a.responsibility_id
 having count(a.user_id) > 50














