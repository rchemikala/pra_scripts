set lines 120
col owner form a10 trunc head "Owner"
col file_name form a60 
col segment_name form a20
col count form 99999999 head "No of | Extents"
select owner,file_name,segment_name,count(*) "Count"
from 
dba_extents e,
dba_data_files d
where e.file_id=d.file_id
and e.tablespace_name='&1'
group by owner,file_name,segment_name
/
