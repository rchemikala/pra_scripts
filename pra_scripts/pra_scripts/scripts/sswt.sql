col event form a15
col p2 form 9999
col sid form 999
col pid form 999
col wait form 999
select a.name,b.pid,b.spid,c.sid,substr(d.event,1,15) event,
       d.p1,d.p2,d.wait_time "Wait",d.seconds_in_wait "Total Wait"
from v$shared_server a,v$process b,V$session c,V$session_wait d
where a.paddr=b.addr
and b.addr=c.paddr(+)
and nvl(c.sid,0)=d.sid(+)
order by 1
/