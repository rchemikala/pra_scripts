col cursor_cache_hits head "Session|Cached|Cursor| %" form 999.99
col soft_parses head "Soft|Parse| %" form 999.99
col hard_parses head "Hard|Parse| %" form 999.99
select
  100 * sess / calls  cursor_cache_hits,
  100 * (calls - sess - hard) / calls soft_parses,
  100 * hard / calls  hard_parses
from
  ( select value calls from v$sysstat where name = 'parse count (total)' ),
  ( select value hard  from v$sysstat where name = 'parse count (hard)' ),
 ( select value sess  from v$sysstat where name = 'session cursor cache hits' )
/
