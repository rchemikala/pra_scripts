set echo off
set feedback off
set head off
set pagesize 100
spool kius.lst
set termout off
@kius &1
spool off
set termout on
set pagesize 100
set echo on
@kius.lst
set head on