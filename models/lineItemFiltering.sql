select l_shipmode, count(*) Count, count(*)/(select Count(*) from {{ source('sf1_lineitem', 'LINEITEM') }})*100 Proportion
from {{ source('sf1_lineitem', 'LINEITEM') }}
group by L_shipmode