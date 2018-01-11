col state form 99999

select file#,dbablk,tch,class,state
from(
   select file#,dbablk,tch,class,state
   from x$bh
   where tch >1000
   order by tch desc)
where rownum <15
/