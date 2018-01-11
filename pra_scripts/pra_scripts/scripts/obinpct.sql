set pagesize 80
set linesize 140
col owner head "Owner" form a10
col segment_name head "Segment" form a30
col tablespace_name head "Tablespace" form a12 trunc
col segment_type head "Type" form a5 trunc
col init head "Ini_Ext|(In MB)" form 999999999
col next head "Next_Ext|(In MB)" form 99999
col pct_increase head "%|Inc" form 99
col max_extents head "Max|Extents"
col min_extents head "Min|Extents"

select owner,
segment_type,
segment_name,
tablespace_name,
INITIAL_EXTENT/1024/1024 "init",
NEXT_EXTENT/1024/1024 "next",
MIN_EXTENTS ,
MAX_EXTENTS ,
PCT_INCREASE   
from 
dba_segments 
where 
pct_increase > 0 and 
owner not in 
('SYS','SYSTEM','MDSYS','AURORA$JIS$UTILITY$','OUTLN','OSE$HTTP$ADMIN') and 
(NEXT_EXTENT/1024/1024) > 10 
order by 1,2,5
/