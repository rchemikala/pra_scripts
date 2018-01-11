select latch#,name,level
from v$latch
where latch#='&1'
/