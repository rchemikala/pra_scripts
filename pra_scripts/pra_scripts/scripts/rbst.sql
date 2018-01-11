col segment_name head "Name" form a10
col status head "Status" form a6 trunc
col xacts head "Act|ive|Tra|nsa|cti|ons" form 99
col extents Head "No Of|Ext|ents" form 9999
col rssize head "Size|in MB" form 9999.99
col aveactive head "Ave|Act|ive|in|MB" form 99999.99
col hwmsize head "High|Water|Mark|in MB" form 9999.99
col optsize Head "Optimal|Size|in MB" form 9999.99
col aveshrink Head "Ave|Shr|ink|in|MB" form 999.99
col gets head "Gets" form 999999999
col waits head "Waits" form 9999
col extends Head "Ext|end" form 999
col shrinks head "Shr|ink" form 999
col wraps form 9999

select segment_name,a.status,xacts,extents,b.rssize/1048576 rssize,aveactive/1048576 aveactive,
	 hwmsize/1048576 hwmsize,optsize/1048576 optsize,aveshrink/1048576 aveshrink,
	 gets,waits,extends,shrinks
from dba_rollback_segs a,v$rollstat b 
where a.segment_id=b.usn(+)
order by 1
/