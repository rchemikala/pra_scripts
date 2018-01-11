set echo off
set feedback off
set head off
set pagesize 100
spool kisn.lst
set termout off
@kisn
spool off
set termout on
set pagesize 100
set echo on
@kisn.lst
set head on