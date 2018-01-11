select   se.username
        ,se.sid
        ,su.extents
      ,su.blocks * to_number(rtrim(p.value))/1048576 as Space
      ,se.sql_hash_value
        ,tablespace
from     v$sort_usage su
        ,v$parameter  p
        ,v$session    se
where    p.name          = 'db_block_size'
and      su.session_addr = se.saddr
and su.blocks*8192/1048576 > 500
order by se.username, se.sid
/