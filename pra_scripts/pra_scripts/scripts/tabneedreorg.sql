col owner form a10
col table_name form a30
col seg_size form 9999999.9999
col table_size_rowlen form 999999.9999
col pct_free form 9999.999
select
a.owner "Owner",
a.table_name Table_name,
sum(bytes)/1024/1024 Seg_size,
sum(AVG_ROW_LEN*NUM_ROWS)/1024/1024 Table_size_rowlen,
(((sum(bytes)/1024/1024)-(sum(AVG_ROW_LEN*NUM_ROWS)/1024/1024))/(sum(bytes)/1024/1024))*100 Pct_free
from dba_tables a ,
dba_segments b
where
a.table_name=b.segment_name and
a.owner in ('APPLSYS','APPS','TS','JTF','AR')
group by
a.owner,
a.table_name,
segment_name
having 
sum(bytes)/1024/1024 > 100 and
(((sum(bytes)/1024/1024)-(sum(AVG_ROW_LEN*NUM_ROWS)/1024/1024))/(sum(bytes)/1024/1024))*100 > 20 
order by 1,3,5
/
