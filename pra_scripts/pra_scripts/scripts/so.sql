set echo off
set head off
set feedback off
col name form a25
col value form 9999.99
select name,value/1048576 value,'MB' 
from v$parameter
where name like '%sort_area%'
/
col name form a23
col value form 99999999999
set echo off
set head off
set feedback off
select name,value 
from v$sysstat 
where name like '%sort%'
/
set head on
col current_users head 'No Of|Users|Sorting|now' form 9999
col total_extents head 'No of|Current|Extents' form 9999999
col used_extents head 'No Of|Used|Extents' form 9999999
col free_extents head 'No Of|Free|Extents' form 999999999
col Added_extents head 'No Of|Extents|Added' form 999999999
col freed_extents head 'No Of|Extents|Freed' form 999999999
col extent_hits head 'No Of|Freed|Extents|reused' form 999999999
col max_size head 'Max Extents|Ever Used' form 999999999
col max_used_size head 'Max Extents|Used By all|Sorts' form 999999999
select current_users,total_extents,used_extents,free_extents,added_extents,
freed_extents,extent_hits,max_size,max_used_size 
from v$sort_segment
/
cle col
col ind_sort_size head 'Largest Sort|(in MB)' form 9999999.999
col total_sort_size head 'Largest|Concurrent|Sort Usage|(in MB)' form 9999999.999
col total_segment_size head 'Current|Sort Segment|Size|(in MB)' form 99999999.999
select (a.max_sort_blocks*b.value/1048576) ind_sort_size, 
	 (a.max_used_blocks*b.value/1048576) total_sort_size,
	 (a.total_blocks*b.value/1048576) total_segment_size
from v$sort_Segment a,v$parameter b
where b.name='db_block_size'
/
rem SQL*Plus script to display sort usage by user with join to v$session
rem to get session information (and correct user in some ver due to bug)
rem
rem  20010130  Mark D Powell   Saved version
rem
column tablespace format a12
column username   format a12
col space Head "Space|Used|in MB" form 9999999.99
break on username nodup skip 1
select   se.username
        ,se.sid
        ,su.extents
        ,su.blocks * to_number(rtrim(p.value))/1048576 as Space
        ,tablespace
from     v$sort_usage su
        ,v$parameter  p
        ,v$session    se
where    p.name          = 'db_block_size'
and      su.session_addr = se.saddr
order by se.username, se.sid
/
set head on
set feedback on
cle bre