col sid form 999
col username form a10
col d head "Dispatcher|Name"
col ss head "Shared|Server"
col Bytes head "Bytes|Processed"
col messages head "Messages|Processed"
col status form a9
col queue head "Current|Queue"
select a.sid,a.username,
	 c.name d,d.name ss,
	 b.circuit,b.status,b.queue,b.messages,b.bytes 
from v$session a,v$circuit b,v$dispatcher c,v$shared_server d
where a.saddr=b.saddr
and b.dispatcher=c.paddr
and b.server=d.paddr(+)
/