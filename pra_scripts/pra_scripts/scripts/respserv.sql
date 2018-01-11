col responsibility_name format a40
col "No.of Users" format 999999
col "server Name" format a50
select responsibility_name ,
(select count(*) from fnd_user_resp_groups where responsibility_id = a.responsibility_id) "No.of Users",
 profile_option_value "Server Name" from
 FND_RESPONSIBILITY_VL a, fnd_profile_option_values b
where
b.profile_option_value like '%ttlprd%'
and b.level_value = a.responsibility_id
order by 2 
/
