select 'alter system kill session '''||sid||','||serial#||''' immediate;' from v$session
where substr(program||module,1,15)=upper('&modulename') and status='ACTIVE'
order by logon_time;
