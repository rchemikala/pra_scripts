col event form a40
col total_waits head "Total|Waits" 
col total_timeouts head "Total|Time Outs" 
col time_waited head "Time|Waited|in Secs" form 999999999.9
col average_wait head "Average|Wait|in ms" form 999999999
select event, total_waits,total_timeouts,(time_waited/100) time_waited, 
	time_waited/(total_waits-total_timeouts) average_wait
from v$system_event
where total_waits-total_timeouts<>0
order by 4
/
