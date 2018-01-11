select
  b.name, p.spid, p.pid, s.sid, s.serial#
from
  sys.v_$bgprocess b,
  sys.v_$process p,
  sys.v_$session s
where
   p.addr = b.paddr and
  s.paddr = p.addr
/
