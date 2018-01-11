set echo off
set linesize 95
set head on
set feedback on
col sid head "Sid" form 9999 trunc
col serial# form 99999 trunc head "Ser#"
col username form a8 trunc
col osuser form a7 trunc
col machine form a20 trunc head "Client|Machine"
col program form a15 trunc head "Client|Program"
col login form a11
col "last call"  form 9999999 trunc head "Last Call|In Secs"
col status form a6 trunc
select count(*) from v$session 
/