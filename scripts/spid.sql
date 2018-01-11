column spid format a5 
column sid format 9999 
column ora_user format a10 
column unix_user format a10 
column osuser format a10 
column server for a12
column username for a15 
column machine for a15 
column whenon format a18 heading "WHEN USER LOGGED ON" 
column whendo format a18 heading "WHEN LAST ACTIVITY" 
set lin 150 
select p.pid, p.spid, s.sid, s.username,lower(s.username) ora_user, p.username unix_user,Status, s.osuser, 
to_char(s.logon_time,'mm/dd/yy hh24:mi:ss') whenon, 
to_char(sysdate - (s.last_call_et) / 86400,'mm/dd/yy hh24:mi:ss') whendo 
from 
v$process p, v$session s 
where 
s.paddr(+) = p.addr and s.status='ACTIVE' order by s.logon_time,s.status;