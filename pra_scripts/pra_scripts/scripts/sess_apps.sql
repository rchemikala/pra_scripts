 select a.sid,a.serial#,substr(a.username,1,10) username,substr(a.osuser,1,10) osuser,
	 substr(a.program||a.module,1,15) program,substr(a.machine,1,22) machine,
	 to_char(a.logon_time,'ddMon hh24:mi') login,
	 last_call_et "last call",status from v$session a, fnd_v$process b where
 b.addr= a.paddr(+) and b.spid = '&1'

