col parent_name form a25
col where form a32
col nwfail_count head "No-Wait|Acqui-|sition|Fail|ures" form 9999
col sleep_count head "Aqui-|sition|Sleeps" form 9999999
col Wtr_slp_count head "Waiter|Sleep|Count" form 9999999
col Longhold_count head "Long|Hold|Count" form 99999
select *
from v$latch_misses 
where nwfail_count+sleep_count+longhold_count<>0
order by sleep_count,nwfail_count,longhold_count
/