## Here is a quick and dirty script I use all-the-time to determine where the time is going for a particular sql_id. If we use it with a insert statement we can see which indexes are being accessed and in what ratios. First the script:

https://ctandrewsayer.wordpress.com/2017/02/16/not-all-indexes-are-created-equally/

set lines 500  
col "Operation" FOR a35 
break on child_number nodup on "Id" nodup on "Operation" nodup on "Name" nodup on cost nodup on CARDINALITY nodup  
col child_number noprint  
col "Id" for 999  
col event for a30  
col cost for 9999999  
col activity for a10  
col active for a3  
var sql_id varchar2(30 char);  
exec :sql_id := '&1'        
  
  
with ash AS (SELECT sql_id  
      ,sql_plan_hash_value  
      ,SQL_PLAN_LINE_ID  
      ,NVL(event,'CPU') event  
      ,nvl2(event,o.object_name,null) object_name  
      ,COUNT(DISTINCT sample_id) cnt  
      ,ROUND(SUM(ash.delta_read_io_bytes/1024/1024 ),2) Read_MB  
      ,MAX(sample_time) most_recent_time  
FROM   v$active_session_history ash  
LEFT JOIN dba_objects o  
  ON   ash.current_obj# = o.object_id  
WHERE  ash.sql_id = :sql_id  
GROUP BY sql_id  
      ,sql_plan_hash_value  
      ,SQL_PLAN_LINE_ID  
      ,NVL(event,'CPU')  
      ,nvl2(event,o.object_name,null)  
ORDER BY 1,2,3,5)  
 ,sp AS (SELECT sp.plan_hash_value  
               ,id  
               ,sql_id  
               ,LPAD(' ',sp.depth,' ')||sp.operation||' '||sp.options "Operation"  
               ,sp.OBJECT_NAME "Name"  
               ,max(sp.cardinality) cardinality  
               ,MAX(sp.io_cost) cost  
               ,sp.object_name  
        FROM   v$sql_plan sp  
        WHERE  sp.sql_id = :sql_id  
        group by sp.plan_hash_value  
               ,id  
               ,sql_id  
               ,LPAD(' ',sp.depth,' ')||sp.operation||' '||sp.options  
               ,sp.object_name  
       )        
 select active  
       ,PLAN_HASH_VALUE  
       ,"Id"  
       ,"Operation"  
       ,"Name"  
       ,cardinality  
       ,cost  
       ,event  
       ,object_name  
       ,activity  
       ,Read_MB  
 From (  
 select CASE WHEN ash.most_recent_time > sysdate-interval'5'second then '*' else ' ' end active  
      ,sp.plan_hash_value  
      ,sp.id "Id"  
      ,sp."Operation"  
      ,sp.object_name "Name"  
      ,sp.cardinality  
      ,sp.cost  
      ,ash.event  
      ,ash.object_name  
      ,DECODE(ash.cnt,NULL,NULL,ash.cnt||' ('||ROUND(100*RATIO_TO_REPORT(ash.cnt) OVER (PARTITION BY sp.plan_hash_value))||'%)') activity  
      ,ash.cnt  
      ,ash.Read_MB  
 from   sp  
left join   ash  
   on  sp.plan_hash_value = ash.sql_plan_hash_value  
  and sp.id = ash.sql_plan_line_id  
  and sp.sql_id = ash.sql_id  
 order by sp.plan_hash_value,sp.id, ash.cnt  
 )  
 order by plan_hash_value, "Id" , cnt  
/