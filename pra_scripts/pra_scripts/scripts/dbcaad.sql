@fm
col size_for_estimate head "Size Of|DB Buffer" form 99999
col buffers_for_estimate head "No Of |DB Buffers" form 999999999
col advice_status Head "Advice|Status" form a10
col ESTD_PHYSICAL_READ_FACTOR head "Estimated|Physical|Read|Factor" form 99.99
col ESTD_PHYSICAL_READS head "Estimated|Physical|Reads" form 9999999999
select size_for_estimate,buffers_for_estimate,advice_status,
	 ESTD_PHYSICAL_READ_FACTOR,ESTD_PHYSICAL_READS 
from v$DB_CACHE_ADVICE
/