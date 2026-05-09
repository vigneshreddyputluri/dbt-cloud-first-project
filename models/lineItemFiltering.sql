select l_shipmode, count(*) Count, count(*)/(select Count(*) from {{ source('sf1000', 'LINEITEM') }})*100 Proportion
from {{ source('sf1000', 'LINEITEM') }}
group by L_shipmode