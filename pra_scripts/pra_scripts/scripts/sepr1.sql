select a.sid,b.pid,a.program cprogram,a.process,b.program sprogram,b.spid
from v$session a,v$process b
where a.paddr(+)=b.addr and
b.spid = &1

/*order by to_number(b.spid)*/
order by 1
/
