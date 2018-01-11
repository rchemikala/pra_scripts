col owner Head "Owner" form a10
col table_name head "Table Name" form a24
col column_name head "Column Name" form a30
col endpoint_number head "End|Point|Number" form 9999999
col endpoint_actual_value head "End|Point|Actual|Value" form a10 trunc

select owner,table_name,column_name,endpoint_number,endpoint_actual_value
from dba_tab_histograms
where table_name=upper('&1')
order by 1,2,3,4
/