cle col
col name form a4
col status form a13
col messages head "Mesages|Processed"
col Bytes head "Bytes|Processed"
col Breaks form 999
col circuit head "Current|Circuit"
col requests head "Requests|Processed"
col Idle head "Idle|Secs"
col Busy form 9999999 head "Busy|Secs"
col load form 99.99 head "Ave|Load"
select a.name,circuit,a.status,a.messages,a.bytes,a.breaks,a.requests,
       trunc(a.idle/100) Idle,trunc(a.busy/100) Busy, 
	 trunc((a.Busy/(a.Busy+a.Idle))*100,2) Load
from v$shared_server a
order by 1
/