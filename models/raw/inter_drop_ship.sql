{{ config(
    materialized='incremental',
    unique_key='sku_idnt',
    incremental_strategy='merge'
) }}

{% set src = source('raw','drop_ship') %}
{% set cols = adapter.get_columns_in_relation(src) %}

select 
        {% for col in cols%}
            {{ col.name }},
        {% endfor %}
        current_timestamp() as added_tmsp

from {{ src }} raw 

{% if is_incremental() %}
where added_tmsp > (select max(added_tmsp) from {{ this }})
{% endif %}