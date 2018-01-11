col name form a28 trunc
col gets form 999999999999
col misses form 999999999
col immediate_gets head "Immediate|Gets" form 99999999999
col immediate_misses head "Imme-|diate|Misses" form 9999999
col latch# head "No" form 999
col pctmiss head "Miss%" form 99.99
col impctmiss head "Miss%" form 99.99
select latch#,name,gets,misses,((misses*100)/(gets+1)) pctmiss,
	 immediate_gets,immediate_misses, 
	 ((immediate_misses*100)/(immediate_gets+1)) impctmiss
from v$latch 
order by pctmiss+impctmiss
/