col file# form 9999
col phyrds head "Phy|Reads" form 999999999
col phywrts head "Phy|writes" form 999999999
col readtim head "Total|Read|Time" form 99999999999
col writetim head "Total|Write|Time" form 9999999999
col avgreadiotim head "Ave|Read|I/O|Time" form 9999999.99
col avgwriteiotim head "Ave|Write|I/O|Time" form 9999999.99
col maxiortm head "Max|Read|I/O|Time" form 999999
col maxiowtm head "Max|Write|I/O|Time" form 99999
select file#,phyrds,readtim,phyrds/readtim avgreadiotim,maxiortm,
	 phywrts,writetim,phywrts/writetim avgwriteiotim,maxiowtm
from v$filestat
order by 2
/