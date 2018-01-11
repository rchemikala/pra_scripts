select a.sid,serial#,substr(a.username,1,10) username,substr(osuser,1,10) osuser,
	 substr(program||module,1,15) program,substr(machine,1,22) machine,
	 to_char(logon_time,'ddMon hh24:mi') login,
src.ext1 , src.space
--	 last_call_et "last call",status
from v$session a ,
(select   se.username
        ,se.sid sid
        ,su.extents ext1
        ,su.blocks * to_number(rtrim(p.value))/1048576 as Space
        ,tablespace
from     v$sort_usage su
        ,v$parameter  p
        ,v$session    se
where    p.name          = 'db_block_size'
and      su.session_addr = se.saddr
) src
where a.sid = src.sid
order by space desc 
/
