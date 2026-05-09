{{config(
    materialized = 'table'
)}}

select * 
from {{source('sf1000', 'ORDERS')}}