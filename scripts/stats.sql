variable jobno number;
variable instno number;
BEGIN
  SELECT instance_number INTO :instno FROM v$instance;
  DBMS_JOB.SUBMIT(:jobno, 'statspack.snap;', trunc(sysdate,'HH24')+((floor(to_number(to_char(sysdate,'MI'))/30)+1)*30)/(24*60), 'trunc(sysdate,''HH24'')+((floor(to_number(to_char(sysdate,''MI''))/30)+1)*30)/(24*60)', TRUE, :instno);
  COMMIT;
END;
/
