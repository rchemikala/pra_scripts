clear col
set head off
set pause off
set pages 0
set verify off
set feedback off

clear breaks
clear compute

column today new_value dba_date
select to_char(sysdate, 'mm/dd/yy hh24:mi') today
       from dual;

break on instance
column instance new_value instance_name
select name instance
      from v$database;

clear breaks
set termout off
spool output.txt

set pagesize 200 linesize 120 verify off
set space 2
ttitle left 'Date: ' format a18 dba_date -
       center 'Extent/Tablespace Report - ' format a4 instance_name -
       right 'Page: ' format 999 sql.pno skip 2

set head on
set verify on
set feedback on
col table_name format a30
col ext format 990
col used format 99,990
col empty format 99,990
col used_pct format 990.99
col next format 99,999,990

Prompt *****************************************************************************
Prompt =========> ORABEAT.sql .... space,extent management reports 
Prompt *****************************************************************************
Prompt
Prompt *****************************************************************************
Prompt REPORT #1
Prompt Checking for Next Extents that will not fit in the current Tablespace
Prompt *****************************************************************************
Prompt

col available_space heading 'Avail(Mb)' format 999.990
col tablespace_name heading TableSp. format a12
col segname heading 'Name'  format a20
col segtype heading 'Type' format a10
col max_nex heading 'Next(Mb)' format 999.990

select b.segment_name                   segname,
    b.segment_type                      segtype,
    a.tablespace_name                   tablespace_name,
    max(a.bytes)/(1024*1024)            available_space, 
    max(b.next_extent)/(1024*1024)      max_nex
from sys.dba_free_space a,
    sys.dba_segments b
where a.tablespace_name = b.tablespace_name
group by a.tablespace_name,
    b.segment_name,
    b.segment_type
having max(b.next_extent) > max(a.bytes)
order by 2 desc;


set verify off;
set feedb on;

Prompt
Prompt *****************************************************************************
Prompt REPORT #2
Prompt Checking for Segments whose extents are nearing the Max Extents limit
Prompt *****************************************************************************
Prompt

col segname heading 'Name'  format a20
col segtype heading 'Type' format a10
col tablespace_name heading TableSp. format a12
col ex heading 'Extents' format 999999
col mx heading 'Max-Ext' format 99999999999
col Next heading 'Next(Mb)' format 999.990

select 	segment_name segname,
	segment_type segtype,
	tablespace_name tablespace_name,
	extents ex,
	max_extents "mx",
	next_extent/1024/1024 "Next" 
from  dba_segments 
where max_extents-extents <= 10 and
      segment_type <> 'CACHE';

set verify off;
set feedb on;

Prompt
Prompt *****************************************************************************
Prompt REPORT #3
Prompt Tablespace Utilization
Prompt *****************************************************************************
Prompt

set heading on 
set lines 200
column fragments heading 'Fragments' justify right for 99,999
column tablespace heading 'Tablespace' justify left format a20 truncated 
column alloc heading 'Size|(Mb) ' justify right format 9,999,999.99 
column used heading 'Used|(Mb) ' justify right format 9,999,999.99 
column unused heading 'Free|(Mb) ' justify right format 9,999,999.99 
column usedpct heading '%Used' justify right format 999.99 
break on report 
compute sum label 'Totals:' of alloc used unused on report 

SELECT u.tblspc "TABLESPACE", 
round(a.fbytes/1024/1024 ,2) "ALLOC", 
round(u.ebytes/1024/1024 ,2) USED, round(a.fbytes/1024/1024-u.ebytes/1024/1024, 2) UNUSED, 
round((u.ebytes/a.fbytes) * 100 ,2) USEDPCT , f.fragments
FROM (SELECT tablespace_name tblspc, 
SUM(bytes) ebytes
FROM dba_extents 
GROUP BY tablespace_name) u, 
(SELECT tablespace_name tblspc, 
SUM(bytes) fbytes 
FROM dba_data_files 
GROUP BY tablespace_name) a,
(select tablespace_name freets,count(*) fragments from dba_free_space
group by tablespace_name) f
WHERE u.tblspc = a.tblspc and f.freets = a.tblspc and f.fragments <> 0 order by 5 desc; 


Prompt
Prompt *****************************************************************************
Prompt REPORT #4
prompt Calculating Table/Index Access Ratio 
Prompt *****************************************************************************
Prompt

column avalue format 999,999,999,990 heading "Table Hits"
column bvalue format 999,999,999,990 heading "Index Hits"
column ht format 990.99 heading "Table %"
column it format 990.99 heading "Index %"
col acr heading "Access"

select a.value avalue,b.
    value bvalue,
    (1-b.value/(a.value+b.value))*100 ht,
    (1-a.value/(a.value+b.value))*100 it,
    decode (sign(75 - CEIL( (1-a.value/(a.value+b.value))*100)),1,'*BAD ACCESS RATIO*',0,'*AVG ACCESS RATIO*','*GOOD ACCESS RATIO*') ACR
from v$sysstat a,
    v$sysstat b
where a.name = 'table scan rows gotten' AND
      b.name = 'table fetch by rowid';

prompt
Prompt *****************************************************************************
Prompt REPORT #5
prompt Objects containing morethan 500 extents
Prompt *****************************************************************************
Prompt

column sn format a40 heading "Name"
column ty format a10 heading "Type"
column tn format a17 heading "Tablespace"
column ex format 99999.9999 heading "Extents"
column by format 99999.9999 heading "Used(Mb)"
column ne format 99999.9999 heading "Next Extent(Mb)"

select segment_name||'('||owner||')' sn,
        segment_type ty,
        tablespace_name tn,
        extents ex,
        bytes/(1024*1024) "by",
        next_extent/(1024*1024) "ne"  
from dba_segments 
where tablespace_name not in ('SYSTEM','TEMP','RBS') 
and extents >= 500 order by bytes desc;

Prompt
Prompt *****************************************************************************
prompt =========>   END OF SPACE AND EXTENT MANAGEMENT REPORT  
Prompt *****************************************************************************
Prompt

clear col
set lines 80
undefine CLIENT
clear breaks
clear compute
set head on
set pause off
ttitle off
set termout on
spool off
exit