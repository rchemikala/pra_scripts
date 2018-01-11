set heading on 
set lines 200

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
order by 5
/

