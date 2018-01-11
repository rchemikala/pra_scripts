SELECT chr(bitand(p1,-16777216)/16777215)||
         chr(bitand(p1, 16711680)/65535) "Lock",
         to_char( bitand(p1, 65535) )    "Mode",
	p1raw,
	p2raw 
    FROM v$session_wait
   WHERE event = 'enqueue'
  ;



