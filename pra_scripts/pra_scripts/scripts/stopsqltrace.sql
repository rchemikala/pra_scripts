 BEGIN
     FOR sess_rec IN ( SELECT sid, serial#
                         FROM v$session )
     LOOP
         sys.dbms_system.set_sql_trace_in_session
            ( sess_rec.sid, sess_rec.serial#, FALSE );
 DBMS_OUTPUT.PUT_LINE('1');
     END LOOP;
 END;