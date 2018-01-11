select a.sid,to_char(start_time,'dd-mon:hh24:mi') start_time,
	 opname,substr(b.module,1,10) Module ,target,totalwork,sofar,(elapsed_Seconds/60) elamin,
	 time_remaining tre
from v$session_longops a, v$session b
where
a.sid = b.sid and
b.status='ACTIVE' and
totalwork <> SOFAR
order by start_time;

