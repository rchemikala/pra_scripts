select inst_id,count(*) from gv$session where status='ACTIVE' group by inst_id
/
