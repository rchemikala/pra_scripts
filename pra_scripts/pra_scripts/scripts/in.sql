select index_name,tablespace_name 
from dba_indexes 
where owner =upper('&1') 
order by 2,1
/
