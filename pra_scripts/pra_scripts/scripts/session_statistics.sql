col value format 999999999999999999
select  c.SID,substr(c.username,1,10),  substr(c.program||c.module,1,15) program ,NAME,VALUE
from v$sesstat a,v$statname b ,v$session c where
a.STATISTIC#=b.STATISTIC# and
a.sid=c.sid
and a.sid = &1 and
a.statistic# in 
(11,12,15,16,20,21,22,23,24,40,41,42,43,44,46,97,98,99,100,115,117,127,129,142,208,
233,234,235,236,245,246,251)
order by a.statistic#
/
