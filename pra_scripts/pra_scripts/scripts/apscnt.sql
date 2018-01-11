select count(*) "No Of Users Loged In Today" from apps.fnd_user where to_char(last_logon_date,'dd-mon-yy')=to_char(sysdate,'dd-mon-yy')
/