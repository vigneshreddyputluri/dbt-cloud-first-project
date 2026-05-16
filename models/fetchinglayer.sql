{{config(
    materialized = 'ephemeral'
)}}

select * 
from {{source('sf1000', 'ORDERS')}}