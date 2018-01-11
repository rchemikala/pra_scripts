spool sess.sql
select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where sid in (select sid
from v$session
where --substr(program||module,1,15)='FNDSCSGN' and
status='INACTIVE' and 
sid > 20 and
last_call_et > 3600)
/


spool sess.sql
select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where sid in (select sid
from v$session_wait
where event like 'SQL%' and 
seconds_in_wait>3600 and
wait_time=0) 
/
spool off

select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where sid in (select sid 
from v$session where 
--status='ACTIVE' 
last_call_et > 3600 and
substr(program||module,1,15) is null)
/


select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where sid in (select sid 
from v$session where command=2)
/

select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where sid in (select sid from v$session_wait where event like 'SQL%' and seconds_in_wait>7200 and wait_time=0)
/

select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where sid in (select sid from v$session where logon_time < sysdate-1/24)
and substr(osuser,1,10)<>'orpprodi' 
and last_call_et > 3600
/
