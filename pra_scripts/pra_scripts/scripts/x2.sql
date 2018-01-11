set linesize 4000
select 'alter tablespace '||tablespace_name||' end backup ;' 
from dba_tablespaces
/
rem select 'drop user '||username||' cascade ;' 
rem from dba_users
rem where username not in ('SYS','SYSTEM','OUTLN','DBSNMP','TRACESVR','MIGRATION','EXPORT')
rem /
rem select 'alter database datafile '''||name||''' autoextend on next 10m maxsize 10240m;' 
rem from v$datafile
rem /
rem select 'alter index '||owner||'.'||index_name||' noparallel;'
rem from dba_indexes
rem where owner not in ('SYS','SYSTEM','OUTLN','DBSNMP','TRACESVR','PERFSTAT')
rem and degree=2
rem /
