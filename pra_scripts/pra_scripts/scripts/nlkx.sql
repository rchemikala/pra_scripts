select sid,decode(type,'TX','Transaction(TX)','TM','DML Enqueue(TM)',type) type,
    id1,id2,
    decode(lmode,0,'None(0)',1,'Null(1)',2,'Row Share(2)',3,'Row Exclu(3)',
            4,'Share(4)',5,'Share Row Ex(5)',6,'Exclusive(6)') lmode,
    decode(request,0,'None(0)',1,'Null(1)',2,'Row Share(2)',3,'Row Exclu(3)',
            4,'Share(4)',5,'Share Row Ex(5)',6,'Exclusive(6)') request1,
    ctime,block
from v$lock
where sid>5
and id2 >1
and ctime > 50
and request=6
and type not in ('MR','RT')
order by decode(request,0,0,2),block,5
/