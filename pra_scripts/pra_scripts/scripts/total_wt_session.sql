/* This Script tells us the total time spent by a session in all the waits */
select event,time_waited as time_spent
from v$session_event
where sid = &1
union all
select b.name,a.value from 
v$sesstat a, v$statname b
where a.statistic#=b.statistic#
and b.name = 'CPU used when call started'
and a.sid = &&1
/