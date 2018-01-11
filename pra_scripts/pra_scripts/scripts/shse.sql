select sid,serial#,username 
from v$session 
where audsid=userenv('sessionid') 
/
