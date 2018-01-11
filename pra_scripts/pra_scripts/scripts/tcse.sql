set echo off
set feedback off
set head off
set pagesize 100
spool tc.lst
set termout off
@tc &1
spool off
set termout on
set pagesize 100
set echo on
@tc.lst
set head on