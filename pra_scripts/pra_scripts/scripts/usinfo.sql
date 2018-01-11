select inst_id "DB Node" ,count(*) " No of Sessions" from gv$session group by inst_id;
col Tot heading "Tot|Login's" format 9999
Col HYD heading "Hyd BPO|Users" format 9999
Col Pune heading "Pune BPO|Users" format 9999
Col AP  heading "AP|Users" format 9999
Col MH  heading "MH|Users" format 9999
Col GJ  heading "GJ|Users" format 9999
Col DL  heading "DL|Users" format 9999
Col KA  heading "KA|Users" format 9999
Col TN  heading "TN|Users" format 9999
Col VSNL heading "VSNL|Users" format 9999
Col PB heading "PB|Users" format 9999
Col BH heading "BH|Users" format 9999
Col KR heading "KR|Users" format 9999
Col RJ heading "RJ|Users" format 9999
Col EBU heading "EBU|Users" format 9999
Col RBU heading "RBU|Users" format 9999
Col ERP heading "ERP|Users" format 9999
select
(select to_char(sysdate,'DD-Mon-yy hh24:mi:ss') "Dt" from dual) "Dt",
(select count(*) from apps.fnd_user where Trunc(last_logon_date)=trunc(sysdate)) "Tot",
(select count(*) from apps.fnd_user where user_name like 'HYD%' and Trunc(last_logon_date)=trunc(sysdate)) "HYD",
(select count(*) from apps.fnd_user where user_name like 'PUN%' and Trunc(last_logon_date)=trunc(sysdate)) "Pune"
,
(select count(*) from apps.fnd_user where user_name like 'TTLAP%' and Trunc(last_logon_date)=trunc(sysdate)) "AP"
,
(select count(*) from apps.fnd_user where user_name like 'TTLMH%' and Trunc(last_logon_date)=trunc(sysdate)) "MH"
,
(select count(*) from apps.fnd_user where user_name like 'TTLGJ%' and Trunc(last_logon_date)=trunc(sysdate)) "GJ"
,
(select count(*) from apps.fnd_user where user_name like 'TTLDL%' or user_name like '%DELHI%' and Trunc(last_logon_date)=trunc(sysdate)) "DL"
,
(select count(*) from apps.fnd_user where user_name like 'TTLKA%' and Trunc(last_logon_date)=trunc(sysdate)) "KA"
,
(select count(*) from apps.fnd_user where user_name like 'TTLTN%' and Trunc(last_logon_date)=trunc(sysdate)) "TN"
,
(select count(*) from apps.fnd_user where (user_name like 'VSNL%' or user_name like 'P1%' or user_name like 'P9%'
) and
Trunc(last_logon_date)=trunc(sysdate)) "VSNL",
(select count(*) from apps.fnd_user where user_name like 'TTLPB%' and Trunc(last_logon_date)=trunc(sysdate)) "PB",
(select count(*) from apps.fnd_user where user_name like 'TTLBH%' and Trunc(last_logon_date)=trunc(sysdate)) "BH",
--(select count(*) from apps.fnd_user where user_name like 'TTLKR%' and Trunc(last_logon_date)=trunc(sysdate)) "KR",
(select count(*) from apps.fnd_user where user_name like 'TTLRJ%' and Trunc(last_logon_date)=trunc(sysdate)) "RJ",
--(select count(*) from apps.fnd_user where user_name like 'EBU%' and Trunc(last_logon_date)=trunc(sysdate)) "EBU",
--(select count(*) from apps.fnd_user where user_name like 'RBU%' and Trunc(last_logon_date)=trunc(sysdate)) "RBU",
(select count(*) from apps.fnd_user where user_name like 'ERP%' and Trunc(last_logon_date)=trunc(sysdate)) "ERP"
from dual
/
