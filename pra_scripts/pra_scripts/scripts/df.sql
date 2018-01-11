set echo off
set head on
set feedback 1
set lines 140
col tablespace_name Head "Tablespace Name|(Maybe Truncated)" form a25 trunc
col file_name head "File Name|(Maybe Truncated)" form a70 trunc
col file_id head "File|No" form 999
col bytes head "Size|In MB" form 99999
col autoextensible head "Auto|Ext" form a5
col maxbytes head "Max|Size|In MB" form 99999
col incr head "Incr|size|In|Blocks" form 99999

select tablespace_name,file_id,file_name,bytes/1048576 bytes,
	 autoextensible,maxbytes/1048576 maxbytes,increment_by incr
from dba_data_files 
order by 1,2
/