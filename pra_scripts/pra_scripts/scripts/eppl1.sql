delete from plan_table where statement_id='xyz'
/
explain plan set statement_id='xyz' for 
SELECT /*+ ORDERED USE_NL(ACC A)*/       a.ACCESS_ID,   a.LEAD_ID AS SOURCE_OBJECT_ID,   
  'Opportunity' AS SOURCE_OBJECT_CODE,       g.GROUP_NAME AS SALES_GROUP_NAME,
         r.SOURCE_LAST_NAME AS LAST_NAME,       r.SOURCE_FIRST_NAME AS 
  FIRST_NAME,       r.SOURCE_JOB_TITLE AS Title,        
  a.SALESFORCE_ROLE_CODE,       a.FREEZE_FLAG,       a.TEAM_LEADER_FLAG,      
   a.CUSTOMER_ID,       a.ADDRESS_ID,       a.SALESFORCE_ID,       
  a.PERSON_ID,       a.PARTNER_CUSTOMER_ID,       a.PARTNER_ADDRESS_ID,       
  a.CREATED_PERSON_ID,       a.REASSIGN_REASON,       a.ORG_ID,       
  a.SALESFORCE_RELATIONSHIP_CODE,       a.DOWNLOADABLE_FLAG,       a.GROUP_ID,
         a.SALES_GROUP_ID,       a.INTERNAL_UPDATE_ACCESS,       
  a.SECURITY_GROUP_ID,       a.PARTNER_CONT_PARTY_ID,       a.OWNER_FLAG,     
    a.CREATED_BY_TAP_FLAG,       a.PRM_KEEP_FLAG,       lookup.MEANING AS 
  SALESFORCE_ROLE,       TO_CHAR(a.LAST_UPDATE_DATE, 'RRRR-MM-DD HH24:MI:SS'),
     DECODE (a.TEAM_LEADER_FLAG,'Y', 'Y', 'N') AS UPDATABLE,       ' ' AS 
  DIRTY_FLAG    
FROM
 asl.asl_acc_opportunity   acc,    
 AS_ACCESSES_ALL a,    
 JTF_RS_RESOURCE_EXTNS r, 
 JTF_RS_GROUPS_TL g,    
 AS_LOOKUPS lookup   
WHERE  acc.lead_id =   a.lead_id   
AND    a.salesforce_role_code = lookup.lookup_code(+)   
AND    lookup.lookup_type(+) = 'ROLE_TYPE'   
AND    a.salesforce_id = r.resource_id   
AND    r.CATEGORY = 'EMPLOYEE'   
AND    SYSDATE BETWEEN r.START_DATE_ACTIVE 
AND    NVL(r.END_DATE_ACTIVE, SYSDATE)   
AND    a.sales_group_id = g.group_id(+)   
AND    g.language(+) = USERENV('LANG')        
ORDER BY a.LEAD_ID 
/
col operation head "Operation" form a40
col options head "Options" form a15
col object_name head "Object|Name" form a10
col position head "Position" form 9999999
col cost head "Cost" form 9999999
col cardinality head "Cardina-|lity" form 999999999
col partition_start head "Part-|ition|Start" form a5
col partition_stop head "Part-|ition|Stop" form a5
SELECT LPAD(' ',2*(LEVEL-1))||operation operation, options, 
	 object_name, position,cost,cardinality,
	 partition_start,partition_stop
    FROM plan_table 
    START WITH id = 0 AND statement_id = 'xyz'
    CONNECT BY PRIOR id = parent_id AND 
    statement_id = 'xyz'
/



