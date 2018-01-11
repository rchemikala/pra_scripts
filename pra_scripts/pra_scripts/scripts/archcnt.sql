select  trunc(COMPLETION_TIME),count(*)  from v$archived_log group by trunc(COMPLETION_TIME)
order by 1
/
