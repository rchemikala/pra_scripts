spool ki
select 'kill -9 '||b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr and
a.sid in (select sid
from v$session
where -- substr(program||module,1,15)= '&1' and
status='INACTIVE' and 
last_call_et > 3600)
/
spool off

spool kill.lst
select 'kill -9 '||b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr and
a.sid in (select sid
from v$session_wait
where event like 'SQL%' and 
seconds_in_wait>3600 and
wait_time=0)
/
spool off


select 'kill -9 '||b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr and
a.sid in (select sid from v$session_wait where event like 'SQL%' and seconds_in_wait>3200 and wait_time=0)
/

select 'kill -9 '||b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr and
a.sid in (select sid 
from v$session where 
last_call_et > 3600 and
substr(program||module,1,15) is null)
/

select 'kill -9 '||b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr and
a.sid in (select sid 
from v$session where command=2)
/

select 'kill -9 '||b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr and
a.sid in (select sid 
from v$session where substr(osuser,1,10)<>'orpprodi' and 
logon_time < sysdate-1/24 and 
last_call_et > 3600)
/




