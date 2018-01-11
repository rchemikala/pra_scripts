col name form a35
col value form a20
set head off
set feedback off
select '               '||upper(name)name,value 
from v$parameter 
where name = 'timed_statistics'
/
set feedback on
set head on
col event form a13 trunc head "Event| Waiting For"
col p1 form 99999999999 trunc
col p2 form 99999999999 trunc
col wait_time form 999 trunc head "Last|Wait|Time"
col program form a13 trunc
col username form a8 trunc
col state form a10
col sid form 999 trunc
col last_call_et  form 9999999 trunc head "Last Call|In Secs"
select a.sid,username,b.program program,
	 last_call_et,
	 event,p1,p2,state,wait_time
from v$session_wait a,V$session b
where b.sid=a.sid
order by 1
/
