col sid form 999
col event form a25
col total_waits head "Total|Waits"
col total_timeouts head "Total|Timeouts"
col time_waited head "Time|Waited"
col average_wait form 99.999 head "Average|Wait"
select * 
from v$session_event 
where event in 'process startup'
or event like 'virtual circuit status' 
union
select 0,a.*,0 
from v$system_event a 
where event in 'process startup'
or event like 'virtual circuit status' 
/