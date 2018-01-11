delete from plan_table 
/
explain plan  for 
SELECT Count(A.bill_ref_no) FROM TTL_BILL_IMAGE A, RA_CUSTOMERS
B, TTL_BILL_AMOUNT C WHERE B.party_id=:party_id and A.account_no
=to_number(B.customer_number) and A.account_no=C.account_no and
A.bill_ref_no=C.bill_ref_no and A.bill_date > sysdate-183
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



