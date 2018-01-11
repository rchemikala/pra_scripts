select event , count(sid) from  v$session_wait group by event having event
not in('SQL*Net message from client',
			'SQL*Net message to client','pipe get','rdbms ipc message','queue messages','jobq slave wait')
/
