col username head "UserName|(May be | Truncated)" form a15 trunc
col user_id head "User|ID" form 9999999
col account_status head "Account|Status|(May be | Truncated)" form a15 trunc
col lock_date head "Lock|Date" form a10
col expiry_date head "Expiry|Date" form a10
col default_tablespace head "Default|Table|space" form a15
col temporary_tablespace head "Temporay|Table|space" form a15
col profile head "User|Profile" form a12

select username,user_id,account_status,lock_date,expiry_date,
	default_tablespace,temporary_tablespace,profile
from dba_users 
/
