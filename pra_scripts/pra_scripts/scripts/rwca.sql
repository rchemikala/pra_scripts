col parameter head "Parameter" form a30

col gets head "Gets" form 999999999999
col misses head "Misses" form 999999999999
col pct_succ_gets head "% Get|Hits" form 999.99
col updates head "No Of|Modifications" form 999999999999
SELECT parameter , max(type),sum(gets) gets , sum(getmisses) misses,
	  100*sum(gets - getmisses) / sum(gets) pct_succ_gets, sum(modifications) updates 
FROM V$ROWCACHE 
WHERE gets > 0 
GROUP BY parameter
/