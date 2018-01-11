select 
'alter table '||owner||'.'||table_name||' move tablespace '||tablespace_name||';'
from dba_tables 
where 
table_name in (
		select
		table_name 
		from 	dba_tables a,
			dba_segments b
		where
		a.table_name=b.segment_name and
		a.owner in ('APPLSYS','APPS','TS')
		group by
		a.owner,
		a.table_name,
		segment_name
		having
		sum(bytes)/1024/1024 > 100 and
(((sum(bytes)/1024/1024)-(sum(AVG_ROW_LEN*NUM_ROWS)/1024/1024))/(sum(bytes)/1024/1024))*100 > 20)
order by owner
/

