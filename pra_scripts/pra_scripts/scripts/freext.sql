col owner heading 'Owner' format a10
col segname heading 'Name'  format a20
col segtype heading 'Type' format a10
col tablespace_name heading TableSp. format a12
col ex heading 'Extents' format 999999
col mx heading 'Max-Ext' format 99999999999
col Next heading 'Next(Mb)' format 999.990

select 	owner owner,
	segment_name segname,
	segment_type segtype,
	tablespace_name tablespace_name,
	extents ex,
	max_extents "mx",
	next_extent/1024/1024 "Next" 
from  dba_segments 
where max_extents-extents <= 10 and
      segment_type <> 'CACHE';

set verify off;
set feedb on;