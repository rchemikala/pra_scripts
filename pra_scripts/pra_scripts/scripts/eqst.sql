SELECT ksqsttyp "Lock",
ksqstget "Gets",
ksqstwat "Waits"
FROM X$KSQST 
where KSQSTWAT>0
order by 3
/