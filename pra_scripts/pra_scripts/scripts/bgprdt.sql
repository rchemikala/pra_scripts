col cprogram form a30 trunc head "Client|Program"
col sprogram form a30 trunc head "Server|Program"
col sid form 999
col pid form 999
col process head "Client|Process|ID" form a10
col spid head "Oracle|Background|ProcessID" form 99999
select a.sid,b.pid,a.program cprogram,a.process,b.program sprogram,b.spid
from v$session a,v$process b 
where a.paddr(+)=b.addr
and b.spid='&1'
/
