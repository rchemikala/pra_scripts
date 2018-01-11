col tablespace_name form a20
col file_name form a50

select tablespace_name,file_id,file_name,bytes/1024/1024 from dba_data_files where tablespace_name in ('ARD','ARX','TSD','TSX','APPLSYSD','APPLSYSX','JTFD','JTFX')
order by 1
/
