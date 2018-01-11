@fm
col sid head "Sid" form 999 trunc
col username head "Username" form a8 trunc
col osuser head "OS User" form a7 trunc
col start_time head "Start Time" form a20
col name head "Undo|Segment" form a10
col used_ublk head "Undo|Blocks|Used" form 999999999
col used_urec head "Undo|Records" form 999999999

select s.sid,s.username,s.osuser,t.start_time,
	 r.name,t.xidusn,t.used_ublk,t.used_urec
from v$session s,v$transaction t,v$rollname r
where s.taddr=t.addr
and   t.xidusn=r.usn
order by 1
/