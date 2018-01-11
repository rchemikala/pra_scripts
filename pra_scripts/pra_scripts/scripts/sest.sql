col name form a61
col value form 9999999999999999999
col sid form 9999
col statistic# head "Stat#" form 9999

accept sid prompt "Give SID or Press Enter for all SID's -> "
select a.sid,a.statistic#,b.name,a.value 
from v$sesstat a,v$statname b
where a.statistic#=b.statistic#
and sid=decode('&sid',null,sid,'&sid')
order by 1,3
/
