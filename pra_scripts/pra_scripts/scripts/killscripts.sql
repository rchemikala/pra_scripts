
select 'kill -9 '||c.spid from
v$session a, v$session_wait b ,v$process c
 where
a.sid = b.sid and b.event='latch free'
and
a.paddr(+)=c.addr
and substr(a.program||module,1,15) in ('LAST10_CALLS_PT','LAST10_CALLS')


select 'kill -9 '||c.spid from
v$session a, v$session_wait b ,v$process c
 where
a.sid = b.sid 
and
a.paddr(+)=c.addr
and substr(a.program||module,1,15) in ('LAST10_CALLS_PT','LAST10_CALLS')


select 'kill -9 '||c.spid from
v$session a, v$session_wait b ,v$process c
 where
a.sid = b.sid and b.event='db file sequential read'
and
a.paddr(+)=c.addr
and substr(a.program||module,1,15) in ('LAST10_CALLS_PT','LAST10_CALLS')


select 'kill -9 '||c.spid from
v$session a, v$session_wait b ,v$process c
 where
a.sid = b.sid and b.event='global cache cr request'
and
a.paddr(+)=c.addr
and substr(a.program||module,1,15) in ('LAST10_CALLS_PT''LAST10_CALLS')


select 'kill -9 '||b.spid from
v$session a,v$process b
where 
a.paddr(+)=b.addr and
to_char(logon_time,'hh24')  < 12
AND
substr(a.program||module,1,15) in ('LAST10_CALLS_PT','LAST10_CALLS')
order by 1