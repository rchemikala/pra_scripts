clear col
clear breaks
clear compute

set termout off


set pages 200
set lines 120
set head on
set verify on
set feedback off
col table_name format a30
col ext format 990
col used format 99,990
col empty format 99,990
col used_pct format 990.99
col next format 99,999,990

Prompt
Prompt *****************************************************************************
Prompt Database Info 
Prompt *****************************************************************************
Prompt

select 
upper(instance_name) "INSTANCE NAME" ,
to_char(STARTUP_TIME,'dd-mon-yy hh24:mi') "RUNNING SINCE",
status,
to_char(sysdate,'dd-mon-yy hh24:mi') "PRESENT DATE" 
from 
v$instance;

Prompt
Prompt *****************************************************************************
Prompt REPORT #1
Prompt No of Users Logged In yesterday.
Prompt *****************************************************************************
Prompt	

select count(*) "No Of Users Loged In Yesterday" 
from apps.fnd_user 
where to_char(last_logon_date,'dd-mon-yy')=to_char(sysdate-1,'dd-mon-yy');

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

Prompt
Prompt *****************************************************************************
Prompt REPORT #3
Prompt Tablespace Utilization
Prompt *****************************************************************************
Prompt

SELECT 
d.tablespace_name "Name", 
d.contents "Type", 
TO_CHAR(NVL(a.bytes / 1024 / 1024, 0),'99G999G990D900') "Size (M)", 
TO_CHAR(NVL(NVL(f.bytes, 0),0)/1024/1024, '99G999G990D900') "Free (MB)", 
TO_CHAR(NVL((NVL(f.bytes, 0)) / a.bytes * 100, 0), '990D00') "Free %" 
FROM sys.dba_tablespaces d, 
( select tablespace_name,
  sum(bytes) bytes 
  from dba_data_files 
 group by tablespace_name) a, 
( select tablespace_name, 
  sum(bytes) bytes 
  from dba_free_space 
  group by tablespace_name) f 
WHERE 
d.tablespace_name = a.tablespace_name(+) AND 
d.tablespace_name = f.tablespace_name(+) AND
TO_CHAR(NVL((NVL(f.bytes, 0)) / a.bytes * 100, 0), '990D00') <= 10 AND
d.tablespace_name not in ('TEMP','RBS')
order by 5;

prompt
Prompt *****************************************************************************
Prompt REPORT #4
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

prompt
Prompt *****************************************************************************
Prompt REPORT #5
prompt Invalid Objects List and Compile statements
Prompt *****************************************************************************
Prompt

Column In format a80 heading "Invalid Objects"

select 
decode(object_type,'PACKAGE BODY','alter package ',concat('alter ',object_type))||
	' '||owner||'.'||object_name||
decode(object_type,'PACKAGE BODY',' compile body ;',' compile ;')  "In"
from   dba_objects 
where  status='INVALID';

Prompt
Prompt *****************************************************************************
prompt =========>   END OF REPORT  
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

