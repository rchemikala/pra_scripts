select a.sid,b.used_ublk  from v$transaction b, v$session a
where b.addr=a.taddr