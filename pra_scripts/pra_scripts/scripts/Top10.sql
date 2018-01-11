select a.* from
(
select hash_value,LOADS,CPU_TIME/1000000,ELAPSED_TIME/100,BUFFER_GETS,EXECUTIONS, 
round(CPU_TIME/ELAPSED_TIME,3)/100 as "%CPU time",round(buffer_gets/executions,3) as "gets/exe" ,SORTS from v$sqlarea
where executions <> 0 
order by buffer_gets desc
)  a 
where rownum < 11
/
