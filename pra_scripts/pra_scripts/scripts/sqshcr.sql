col first_load_time form a10 head "First|Load|Time"
col sql_text form a25
col loaded_versions head "Loa|ded|Vers|ions" form 999
col open_versions head "Open|Vers|ions" form 999
col kept_versions head "Kept|Vers|ions" form 999
Col users_opening head "Users|Ope|ning" form 9999
Col users_executing head "Users|Execu|ting" form 9999
Col parsing_user_id head "Par|sing|User|id" form 9999
col reason head "Reason For Cursor|Not Being Shared" form a20
select sql_text,first_load_time,parsing_user_id,
	 decode(b.unbound_cursor,'Y','-Child Cursor not fully built-','')||
	 decode(b.sql_type_mismatch,'Y','-Sql Type Mismatch-','')||
	 decode(b.optimizer_mismatch,'Y','-Optimizer Mode Mismatch-','')||
	 decode(b.outline_mismatch,'Y','-Outline Mismatch-','')||
	 decode(b.stats_row_mismatch,'Y','-Statistics Mismatch-','')||
	 decode(b.literal_mismatch,'Y','-Non-Data Literal Mismatch-','')||
	 decode(b.sec_depth_mismatch,'Y','-Security Mismatch-','')||
	 decode(b.explain_plan_cursor,'Y','-Explain Plan Cursor Hence Not Shared-','')||
	 decode(b.buffered_dml_mismatch,'Y','-Buffered DML Mismatch-','')||
	 decode(b.pdml_env_mismatch,'Y','-PDML Mismatch-','')||
	 decode(b.inst_drtld_mismatch,'Y','-Insert Direct Load Mismatch-','')||
	 decode(b.slave_qc_mismatch,'Y','-Slave Cursor-','')||
	 decode(b.typecheck_mismatch,'Y','-Child Not Fully Optimized-','')||
	 decode(b.auth_check_mismatch,'Y','-Child Authorization Failure-','')||
	 decode(b.bind_mismatch,'Y','-Bind Metadata Mismatch-','')||
	 decode(b.describe_mismatch,'Y','-Type Check Heap Not Present During Child Describe-','')||
	 decode(b.language_mismatch,'Y','-Language Mismatch-','')||
	 decode(b.translation_mismatch,'Y','-Child Cursor Base Objects Mismatch-','')||
	 decode(b.insuff_privs,'Y','-Insufficient Privileges On Objects Referenced In Child-','')||
	 decode(b.insuff_privs_rem,'Y','-Insufficient Privileges On Remote Objects-','')||
	 decode(b.remote_trans_mismatch,'Y','-Remote Base Objects Of The Child Dont Match-','') reason,
	 loaded_versions,open_versions,
	 kept_versions,users_opening,users_executing
from v$sqlarea a,v$sql_shared_cursor b
where a.address=b.kglhdpar
and (
	loaded_versions>1 OR
	open_versions>1 OR
	kept_versions>1) 
/*where lower(sql_text) like 'select * from x%'*/
/
