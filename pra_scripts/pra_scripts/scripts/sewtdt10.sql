select a.sid,substr(b.username,1,10) username,b.state,substr(b.osuser,1,10) osuser,
	 substr(b.program||b.module,1,15) program,substr(b.machine,1,22) machine,
	 a.event,a.p1,b.sql_hash_value
from v$session_wait a,V$session b
where b.sid=a.sid
and a.event not in('SQL*Net message from client','SQL*Net message to client',
			'smon timer','pmon timer')
and username is not null
order by 6
/



select
event,
p1,
p2
from
v$session_wait
where
sid =52

select
segment_name,
segment_type
from
dba_extents
where
file_id = 126
and 8757 between block_id and (block_id + blocks - 1)