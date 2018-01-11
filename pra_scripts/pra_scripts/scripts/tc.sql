select 'exec dbms_system.set_ev('||sid||','||serial#||',10046,12,'''')'
from v$session
where sid=&1
/