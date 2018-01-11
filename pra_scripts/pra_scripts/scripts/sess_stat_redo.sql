select  c.SID,substr(c.username,1,10),  substr(c.program||c.module,1,15) program ,NAME,VALUE
from v$sesstat a,v$statname b ,v$session c where
a.STATISTIC#=b.STATISTIC# and
a.sid=c.sid
and class=2  and name like '%redo%'
and value > 200000
order by value
/
