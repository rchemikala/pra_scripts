select a.sid,b.pid,a.program cprogram,a.process,b.program sprogram,b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr
/*order by to_number(b.spid)*/
and a.sid in (&1)
order by 1
/
