set verify off
set feedback off
set echo off
set head off
prompt Give the user on whose objects you wish to create synonyms
accept user
prompt Give the role to which you want to grant access
accept role
spool syn.sql
select 'create public synonym '||object_name||' for '||object_name||' ;'
from   dba_objects
where  owner=upper('&user')
and    object_type in('PACKAGE','PROCEDURE','FUNCTION','TABLE','VIEW','SEQUENCE');

select 'grant '|| 
        decode(object_type,'TABLE',' select,insert,update,delete ',
                           'VIEW',' select,insert,update,delete ',
                           'PROCEDURE',' execute ',
                           'FUNCTION',' execute ',
                           'PACKAGE',' execute ',
                           'SEQUENCE',' select ')
               ||' on '||owner||'.'||object_name||' to &role ;'
from dba_objects
where object_type in('PACKAGE','PROCEDURE','FUNCTION','TABLE','VIEW','SEQUENCE')
and   owner=upper('&user')
order by object_type;
spool off
@syn