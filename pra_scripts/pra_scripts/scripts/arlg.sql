bre on comp_day
col sequence# head "Seq#" form 99999
col comp_day head "Archived|Day" form a9
col comp_time head "Arch-|ived|Time" form a5
col name head "Archive File Name" form a45
col first_change# head "First|Change" form 99999999999
col next_change# head "Next|Change" form 99999999999
select sequence#,to_char(completion_time,'dd-mon-yy') comp_day,
	 to_char(completion_time,'hh24:mi') comp_time,
	 name,first_change#,next_change#
from v$archived_log
order by 1
/
cle bre
