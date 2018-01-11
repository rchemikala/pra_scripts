col ktuxeusn head "RBS|No" form 999
col ktuxeslt head "RBS|Slot" form 9999999
col ktuxesqn head "RBS|Wrap" form 9999999

select ktuxeusn,ktuxeslt,ktuxesqn,ktuxesiz
from x$ktuxe
where ktuxecfl='DEAD'
/