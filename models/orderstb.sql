{{ config (

    materialized = 'incremental',
    unique_key = 'payment_id',
    incremental_strategy = 'merge'

) }}

select 
    
    O_ORDERKEY payment_id, 
    O_ORDERSTATUS payment_type, 
    O_ORDERDATE payment_date

from {{ source("fetching_layer_schema", "FETCHINGLAYER") }} as S 

{% if is_incremental() %} 
    where payment_date > ( select max(payment_date) from {{ this }} )
{% endif %}


