col first_load_time form a10 head "First|Load|Time"
col sql_text form a15
col loaded_versions head "Loaded|Vers|ions" form 999
col open_versions head "Open|Vers|ions" form 999
col kept_versions head "Kept|Vers|ions" form 999
Col users_opening head "Users|Opening" form 9999
Col users_executing head "Users|Execu|ting" form 9999
col loads form 9999
col Executions form 9999 head "Execu|tions"
col parse_calls head "Parse|Calls" form 9999
Col parsing_user_id head "Parse|User" form 9999
Col child_number Head "Child|Number" form 9999
select  sql_text,first_load_time,parsing_user_id,child_number,
loaded_versions,open_versions,kept_versions,users_opening,
users_executing,loads,executions,parse_calls 
from v$sql 
/*where lower(sql_text) like 'select * from x%'*/

/
