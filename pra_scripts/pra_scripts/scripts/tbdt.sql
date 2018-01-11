col owner head "Owner" form a15
col table_name head "Table Name" form a30
col chain_cnt head "Chain|Count" form 999999
col pct_free head "%|Fr|ee" form 99
col pct_used head "%|Us|ed" form 99
col avg_space head "Avg|Free|Space|In A|Block" form 9999
col avg_row_len head "Avg|Row|Length" form 99999
col ini_trans head "Ini|Trans" form 999
col freelists head "Free|Lists" form 999
col Last_analyzed head "Anal|yzed|Date" form a6
select owner,table_name,to_char(last_analyzed,'dd-mon') last_analyzed,
	 chain_cnt,pct_free,pct_used,avg_space,avg_row_len,ini_trans,freelists
from dba_tables 
where table_name like upper('%&1%')
/
