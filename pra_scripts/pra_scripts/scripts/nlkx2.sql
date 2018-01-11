select 'alter system kill session '''||sid||','||serial#||''';'
from v$session
where 
sid in(
select sid
  from v$lock
  where sid>30
  and type not in ('MR','RT')
  and lmode=6
  and id2 in
(select id2 from gv$lock 
where sid>30
and id2 >1
and ctime > 50
and request=6
and type not in ('MR','RT')
)) and status='INACTIVE'
/



