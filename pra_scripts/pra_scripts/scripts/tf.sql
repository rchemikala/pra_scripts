set echo off
set head on
set feedback 1
col tablespace_name Head "Tablespace Name|(Maybe Truncated)" form a17 trunc
col file_name head "File Name|(Maybe Truncated)" form a53 trunc
col bytes head "Size|In MB" form 99999
col maxbytes head "Max|Size|In MB" form 99999
col incr head "Incr|size|In|Blocks" form 99999
select tablespace_name,file_name,bytes/1048576 bytes,
	 maxbytes/1048576 maxbytes,increment_by incr 
from dba_temp_files 
order by 3
/