select 'alter system kill session '''||sid||','||serial#||''';'
from v$session where sid in 
(
select a.sid
from v$session_longops a, v$session b
where
a.sid = b.sid and
b.status='ACTIVE' and
totalwork <> SOFAR
and substr(b.module,1,8) in ('CSXSRISR','CSCCCCRC') and time_remaining > 100
)
