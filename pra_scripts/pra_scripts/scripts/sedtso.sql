Col  username format a10
select
        se.username,
        se.sid,
        su.extents,
        su.blocks * to_number(rtrim(p.value))/1048576 as Space,
        tablespace,
	substr(program||module,1,15) program,
	 to_char(logon_time,'ddMon hh24:mi') login
from     v$sort_usage su
        ,v$parameter  p
        ,v$session    se
where    p.name          = 'db_block_size'
and      su.session_addr = se.saddr
/
