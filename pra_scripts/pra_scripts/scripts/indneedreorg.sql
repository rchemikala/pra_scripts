col owner form a10
col segment_name form a30
select 
owner,
segment_name,
sum(bytes)/1024/1024
from dba_segments  
where 
segment_name in (
select index_name from dba_indexes where 
table_name in (
		select
		table_name
		from 	dba_tables a,
			dba_segments b
		where
		a.table_name=b.segment_name and
		a.owner in ('APPLSYS','APPS','TS','JTF')
		group by
		a.owner,
		a.table_name,
		segment_name
		having
		sum(bytes)/1024/1024 > 100 and
(((sum(bytes)/1024/1024)-(sum(AVG_ROW_LEN*NUM_ROWS)/1024/1024))/(sum(bytes)/1024/1024))*100 > 20)
)
group by owner,segment_name
order by owner
/