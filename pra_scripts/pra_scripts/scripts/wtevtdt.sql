select 
a.sid,serial#,substr(username,1,10) username,substr(osuser,1,10) osuser,
     substr(program||module,1,15) program,substr(machine,1,22) machine,
     to_char(logon_time,'ddMon hh24:mi') login,
     last_call_et "last call",status
 from v$session a, v$session_wait b 
 where 
a.sid = b.sid and b.event=&1
 order by 1