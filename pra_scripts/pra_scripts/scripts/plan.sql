delete from plan_table where statement_id='xyz'
/
SELECT qs_v_tabbre_filenum.filenum pppafnmbr, tabeve.codeve pppacstc
 FROM mtapps.qs_v_tabbre_filenum,
      mtapps.qs_v_doslie_pro_bre,
      memoip2.tabpro,
      memoip2.tabeve,
      mtapps.qs_v_tabbre_sub
WHERE qs_v_doslie_pro_bre.idedos2 = qs_v_tabbre_filenum.idebre AND
      tabpro.idepro = qs_v_doslie_pro_bre.idedos1 AND
      qs_v_tabbre_sub.ideeve = tabeve.ideeve AND
      qs_v_doslie_pro_bre.idedos2 = qs_v_tabbre_sub.idebre AND
      tabpro.idepro = qs_v_doslie_pro_bre.idedos1 AND
      tabpro.idepro = 6787148
/
col operation head "Operation" form a25
col options head "Options" form a15
col object_name head "Object|Name" form a17
col cost head "Cost" form 999999999
col cardinality head "Cardina-|lity" form 99999999999
col partition_start head "Part-|ition|Start" form a5
col partition_stop head "Part-|ition|Stop" form a5
SELECT LPAD(' ',1*(LEVEL-1))||operation operation, options, 
	object_name, cost,cardinality,
	 partition_start,partition_stop
    FROM plan_table 
    START WITH id = 0 AND statement_id = 'xyz'
    CONNECT BY PRIOR id = parent_id AND 
    statement_id = 'xyz'
/
