col sid form 999
col event form a40
col total_waits head "Total|Waits" 
col total_timeouts head "Total|Time Outs" 
col time_waited head "Time|Waited" form 99999
col average_wait head "Average|Wait" form 99999
col max_wait head "Max|Wait" form 99999
accept sid prompt "Give SID or Press Enter for all SID's -> "
select *
from v$session_event
where sid=decode('&sid',null,sid,'&sid')
order by 1,2
/
