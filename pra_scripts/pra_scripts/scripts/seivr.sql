select sid,serial#,substr(username,1,10) username,substr(osuser,1,10) osuser,
	 substr(program||module,1,15) program,substr(machine,1,22) machine,
	 to_char(logon_time,'ddMon hh24:mi') login,
	 last_call_et "last call",status
from v$session
where username='TTLIVR' and status='ACTIVE'
order by 1
/
