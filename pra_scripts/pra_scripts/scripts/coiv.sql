set echo off
set feedback off
set head off
set pagesize 100
spool iv.lst
set termout off
@iv
spool off
set termout on
set pagesize 100
set echo on
@iv.lst
@swiv
