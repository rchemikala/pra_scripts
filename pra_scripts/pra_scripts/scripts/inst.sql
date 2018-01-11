col name head "Index Name" form a30
col lf_rows head "Leaf|Rows"
col del_lf_rows head "Deleted|Leaf|Rows"
col lf_rows_len head "Leaf|Rows|length" 
col del_lf_rows_len head "Deleted|Leaf|Rows|length" 
col pct_deleted head "%|Leaf|Rows|Dele|-ted" form 999.99
col distinctiveness head "%|Dist|inct|values" form 999.99
select name,lf_rows,del_lf_rows,
	 del_lf_rows*100/decode(lf_rows,0,1,lf_rows) pct_deleted,
	 lf_rows_len,del_lf_rows_len,
	 distinct_keys*100/decode(lf_rows,0,1,lf_rows) distinctiveness
from index_stats
/