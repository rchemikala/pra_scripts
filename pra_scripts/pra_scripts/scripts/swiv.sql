set echo off
set feedback off
set pagesize 100
set head off
Select 'The Following Objects are still INVALID' from dual
/
set head on
col owner form a15
col object_type form a15
col object_name form a60
set feedback on
select	owner,object_type,object_name
from   	dba_objects 
where		status='INVALID'
order by	owner,object_type,object_name
/
set feedback 1
set echo on
