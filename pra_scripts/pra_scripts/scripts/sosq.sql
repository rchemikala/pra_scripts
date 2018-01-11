set long 10000
col sid form 999 trunc
col serial# form 99999 trunc head "Ser#"
col sortsize head "Sort|Size|in MB" form 9999.99
col sql_text head "sql" form a70
select b.sid,b.serial#,(c.blocks*to_number(rtrim(d.value))/1048576) sortsize,a.sql_text
from v$sql a,v$session b,v$sort_usage c,v$parameter d
where a.address=b.sql_address
and b.saddr=c.session_addr
and d.name='db_block_size'
/