select count(*),substr(a.program||module,1,15)
from v$session a
group by 
substr(a.program||module,1,15)
/