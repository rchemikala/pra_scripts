col owner head "Owner" form a8
col name head "Object|Name" form a30
col type head "Object|Type" form a12
col sharable_mem head "Sharable|Memory|in KB" form 99999
col loads head "Loads" form 99999
col executions head "Execu|tions" form 99999
col locks head "Locks" form 999
col pins head "Pins" form 999
col kept head "Kept ?" form a6
select owner,name,type,sharable_mem/1024 sharable_mem,loads,
	 executions,locks,pins, kept
from v$db_object_cache 
where type in ('PACKAGE','PACKAGE BODY','PROCEDURE','SEQUENCE','TRIGGER')
order by 1,6,4
/