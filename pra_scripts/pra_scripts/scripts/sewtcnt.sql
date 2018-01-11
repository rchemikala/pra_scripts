select
substr(b.program||b.module,1,10) "Program",a.event "Event" , count(*)
from v$session_wait a,V$session b
where b.sid=a.sid
and (a.sid>20 and event not in('SQL*Net message from client',
			'SQL*Net message to client','pipe get','rdbms ipc message','queue messages','jobq slave wait')
or (a.sid<=20 and event not in ('rdbms ipc message','smon timer',
	'pmon timer','SQL*Net message from client','gcs remote message')))
group by substr(b.program||b.module,1,10), a.event
/
