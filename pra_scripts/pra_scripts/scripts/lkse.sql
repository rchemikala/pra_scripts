set echo off
col sid form 9999
col id1 form 9999999999
col id2 form 9999999999
col lmode head "Lock Held" form a14
col request1 head "Lock Request" form a16
col type head "Lock Type" form a15
col ctime head "Time|Held" form 999999
col block head "No Of |Sessions|Waiting|For This|Lock" form 99999
select sid,decode(type,'TX','Transaction(TX)','TM','DML Enqueue(TM)',type) type,
	 id1,id2,
	 decode(lmode,0,'None(0)',1,'Null(1)',2,'Row Share(2)',3,'Row Exclu(3)',
		 4,'Share(4)',5,'Share Row Ex(5)',6,'Exclusive(6)') lmode,
	 decode(request,0,'None(0)',1,'Null(1)',2,'Row Share(2)',3,'Row Exclu(3)',
		 4,'Share(4)',5,'Share Row Ex(5)',6,'Exclusive(6)') request1,
	 ctime,block
from v$lock 
where sid>5
and type not in ('MR','RT')
and id2=&1 
--and rownum < 10
order by decode(request,0,0,2),block,5
/