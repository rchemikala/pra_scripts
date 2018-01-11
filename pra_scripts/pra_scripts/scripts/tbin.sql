col table_owner Head "Owner" form a10
col table_name head "Table name" form a29
col index_name head "Index Name" form a32
col column_name Head "Column name" form a19
col column_position head "Col|umn|Pos|iti|on" form 99
select table_owner,table_name,index_name,column_position,column_name
from dba_ind_columns 
where table_name like upper('%&1%') 
order by 1,2,3,4
/