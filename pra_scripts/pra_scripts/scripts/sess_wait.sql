select  a.SID,substr(a.username,1,10),  substr(c.program||c.module,1,15) program ,NAME,VALUE
 from v$sesstat a,v$statname b ,v$session c where
a.STATISTIC#=b.STATISTIC#
a.sid=c.sid
and class=2  and name = 'redo size'  order by value
/
