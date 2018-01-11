col tablespace_name head "Name" form a20
col block_size head "Block|Size|In KB" form 999
col pct_increase head "Pct|Inc" form 999
col status head "Status" form a10
col extent_management head "Ext|Mange" form a10
col segment_space_management head "Segment|Space|Manage" form a10
select tablespace_name,block_size/1024 "block_size",
	pct_increase,status,extent_management,
	segment_space_management
from dba_tablespaces
/
