select a.sid,
	 decode(command,0,'None',2,'Insert',3,'Select',
		 6,'Update',7,'Delete',10,'Drop Index',12,'Drop Table',
		 45,'Rollback',47,'PL/SQL',command) command,
	 event,p1,p2,p3,state,wait_time
from v$session_wait a,V$session b
where b.sid=a.sid
and b.status='ACTIVE' 
and (a.sid>20 and event not in('SQL*Net message from client',
			'SQL*Net message to client','pipe get','rdbms ipc message','queue messages','jobq slave wait')
or (a.sid<=20 and event not in ('rdbms ipc message','smon timer',
	'pmon timer','SQL*Net message from client','gcs remote message')))
order by decode(event,'pipe get','A',event),p1,p2
/
