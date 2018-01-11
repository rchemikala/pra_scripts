select s.sid,s.username,s.osuser,t.start_time,t.used_ublk,t.used_urec 
from v$session s,v$transaction t
where s.taddr=t.addr
/