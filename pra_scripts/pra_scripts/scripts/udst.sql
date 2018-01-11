col begin head "Start Time" form a15
col undoblks head "Undo|Blocks" form 99999
col txncount head "Trans|actions" form 99999
col maxconcurrency head "Max|Conc|Trans|actions" form 99999
col maxquerylen head "Lon|gest|Query|In|Secs" form 99999
col UNXPBLKREUCNT head "Unexp|Blocks|Reused" form 99999
col UNXPBLKRELCNT head "Unexp|Blocks|Reloc" form 99999
col unxpstealcnt head "Unexp|Blocks|stolen" form 99999
col EXPBLKREUCNT head "Exp|ired|Blocks|Reused" form 99999
col EXPBLKRELCNT head "Exp|ired|Blocks|Reloc" form 99999
col expstealcnt head "Exp|ired|Blocks|stolen" form 99999
col ssolderrcnt head "SS|Old|Errors" form 99999
col nospaceerrcnt head "No|Space|Errors" form 99999
select to_char(begin_time,'dd-mon hh24:mi:ss') Begin,undoblks,txncount,maxconcurrency,
	 maxquerylen,unxpblkreucnt,unxpblkrelcnt,unxpstealcnt
	 expstealcnt,expblkrelcnt,expblkreucnt,ssolderrcnt,nospaceerrcnt
from v$undostat
order by nospaceerrcnt,ssolderrcnt,begin_time
/