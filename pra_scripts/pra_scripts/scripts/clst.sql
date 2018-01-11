col owner Head "Owner" form a10
col table_name head "Table Name" form a20
col column_name head "Column Name" form a25
col nullable Head "N|U|L|L" form a1
col num_distinct Head "Num|Dist|inct" form 9999999
col density head "Den|si|ty" form 99
col num_nulls head "Num|Nulls" form 9999999
col num_buckets head "Num|Buck|ets" form 999
col avg_col_len head "Ave|Col|umn|Len|gth" form 999
select owner,table_name,column_name,
	 nullable,num_distinct,
	 density,num_nulls,num_buckets,avg_col_len
from dba_tab_columns
where table_name=upper('&1')
order by 1,2,3
/