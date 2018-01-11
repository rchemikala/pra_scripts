select sid,substr(program||module,1,15) program,substr(machine,1,22) machine,action,status
from v$session
where sid in (&1)
order by 1
/
