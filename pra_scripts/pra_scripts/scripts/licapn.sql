col sid form 9999
col username form a10
col terminal form a20
col program form a20
SELECT SID,USERNAME,TERMINAL,PROGRAM 
FROM V$SESSION  
WHERE SADDR in    
	(SELECT KGLLKSES 
	 FROM X$KGLLK LOCK_A     
	 WHERE KGLLKREQ = 0      
	 AND EXISTS 
		(SELECT LOCK_B.KGLLKHDL 
		FROM X$KGLLK LOCK_B
                WHERE  LOCK_A.KGLLKHDL = LOCK_B.KGLLKHDL
                AND KGLLKREQ > 0)
	)
/