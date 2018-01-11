select opname,totalwork,sofar,start_time,time_remaining 
from v$session_longops 
where totalwork<>sofar
/
