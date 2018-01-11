col partition_name head "Partition|Name" form a10
col tablespace_name head "Tablespace|Name" form a17
col partition_position head "Pos|iti|on" form 999
col subpartition_count head "No Of|Sub|Parti|tions" form 9999
col high_value head "High Value" form a25

select partition_position,partition_name,tablespace_name,
	 subpartition_count,high_value,blocks,empty_blocks
from dba_tab_partitions
where table_name like upper('%&1%')
order by 1
/
