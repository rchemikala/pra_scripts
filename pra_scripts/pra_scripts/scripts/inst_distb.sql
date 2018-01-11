select  inst_id,machine,count(*) from gv$session  where machine like '%TTLPRD%'group by
inst_id,machine order by machine
/
