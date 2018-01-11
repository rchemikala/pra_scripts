select  ((sum(bytes)-sum(avg_row_len*NUM_ROWS))/sum(bytes))*100
 from dba_tables a,dba_segments b where
a.table_name =b.segment_name and a.table_name like '&1'
/
