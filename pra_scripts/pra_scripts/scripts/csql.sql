col sql_text form a80
set lines 120
select sql_text from v$sqltext where hash_value=
(select sql_hash_value from v$session where sid=&sid)
order by piece
/