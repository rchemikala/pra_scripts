col event# form 9999
col name form a40
col parameter1 form a20
col parameter2 form a15
col parameter3 form a10
select event#,name,parameter1,parameter2,parameter3
from v$event_name
order by lower(name)
/