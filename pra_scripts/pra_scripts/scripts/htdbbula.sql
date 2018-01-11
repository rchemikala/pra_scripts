col state form 99999

select file#,dbablk,tch,class,state 
from(
	select file#,dbablk,tch,class,state 
	from x$bh 
	where hladdr in(
		select addr 
		from v$latch_children 
		where child# = (
			select child#
			from (
				select child#
				from v$latch_children 
				where latch#=66  
				order by misses desc)
			where rownum=1))
		order by tch desc)
where rownum <15 
/
