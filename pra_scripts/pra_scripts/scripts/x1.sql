set echo off
set feedback off
set head off
set pagesize 100
spool x2.lst
set termout off
@x2
spool off
set termout on
set pagesize 100
set echo on
@x2.lst
set head on
set feedback 1