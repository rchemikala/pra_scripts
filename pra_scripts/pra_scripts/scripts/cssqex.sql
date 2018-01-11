set head on
set pagesize 100
set long 4000
col sql_text form a45
col parse_calls head "Parse|Calls" form 999999
col Executions form 999999 head "Execu|tions"
col disk_reads form 999999999 head "Disk|Reads"
col buffer_gets form 999999999 head "Buffer|Gets"
col rows_processed form 999999999 head "Rows|Processed"
set echo on

select sql_text,parse_calls,executions,disk_reads,buffer_gets,rows_processed
from v$sql 
where executions > 100000
order by 3
/
set echo off