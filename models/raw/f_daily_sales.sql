{{ config(
    materialized='incremental',
    unique_key='sku_idnt',
    incremental_strategy='merge'
) }}

{%- set ds = ref('int_drop_ship') -%}
{%- set cf = ref('int_cust_fram') -%}
{%- set mtmk = ref('int_mtmk_sales') -%}
{%- set rtk = ref('int_retake') -%}

select *
from {{ cf }} cf 
full join {{ ds }} ds on cf.sku_idnt = ds.sku_idnt
full join {{ mtmk }} mtmk on cf.sku_idnt = mtmk.sku_idnt
full join {{ rtk }} rtk on cf.sku_idnt = rtl.sku_idnt

{% if is_incremental() %}
where added_tmsp > (select max(added_tmsp) from {{ this }})
{% endif %}


