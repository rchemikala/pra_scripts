col tablespace_name Head "Tablespace Name|(Maybe Truncated)" form a17 trunc
col initial_extent head "Initial|Extent|(In MB)" form 9999.99
col next_extent head "Next|Extent|(In MB)" form 9999.99
col status head "Status" form a10
col contents head "Contents" form a10
col extent_management head "Extent|Management" form a10
col allocation_type head "Allocation|Type" form a10
select tablespace_name,(initial_extent/1048576) initial_extent,
	 (next_extent/1048576) next_extent,
	 status,contents,extent_management,allocation_type
from dba_tablespaces
/
