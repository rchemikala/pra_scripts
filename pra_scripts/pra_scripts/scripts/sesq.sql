col sid form 999
col curr form a80 head "     Current SQL"
bre on sid skip 2
set long 10000
select a.sid sid,b.sql_text curr
from v$session a, v$sql b
where a.sql_address=b.address
order by 1
/
cle bre
