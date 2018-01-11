set echo off
set feedback off
set head off
set pagesize 100
spool ki.lst
set termout off
@ki &1
spool off
set termout on
set pagesize 100
set echo on
@ki.lst
set head on