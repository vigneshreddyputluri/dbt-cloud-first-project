{{ config(
    materialized='incremental',
    unique_key='sku_idnt',
    incremental_strategy='merge',
    on_schema_change='ignore'
) }}

with cf as (
    select * from {{ ref('int_cust_fram') }}
),

ds as (
    select * from {{ ref('int_drop_ship') }}
),

mtmk as (
    select * from {{ ref('int_mtmk_sales') }}
),

rtk as (
    select * from {{ ref('int_retake') }}
)

select

    coalesce(cf.sku_idnt, ds.sku_idnt, mtmk.sku_idnt, rtk.sku_idnt) as sku_idnt,

    coalesce(cf.store_idnt, ds.store_idnt, mtmk.store_idnt, rtk.store_idnt) as store_idnt,

    coalesce(cf.supp_idnt, ds.supp_idnt, mtmk.supp_idnt, rtk.supp_idnt) as supp_idnt,

    coalesce(cf.prom_idnt, ds.prom_idnt, mtmk.prom_idnt, rtk.prom_idnt) as prom_idnt,

    coalesce(cf.chnl_idnt, ds.chnl_idnt, mtmk.chnl_idnt, rtk.chnl_idnt) as chnl_idnt,

    coalesce(cf.loc_type_cde, ds.loc_type_cde, mtmk.loc_type_cde, rtk.loc_type_cde) as loc_type_cde,

    coalesce(cf.rglr_sale_amt, ds.rglr_sale_amt, mtmk.rglr_sale_amt, rtk.rglr_sale_amt) as rglr_sale_amt,

    coalesce(cf.rglr_sale_vat_amt, ds.rglr_sale_vat_amt, mtmk.rglr_sale_vat_amt, rtk.rglr_sale_vat_amt) as rglr_sale_vat_amt,

    coalesce(cf.rglr_sale_qty, ds.rglr_sale_qty, mtmk.rglr_sale_qty, rtk.rglr_sale_qty) as rglr_sale_qty,

    coalesce(cf.rglr_profit_amt, ds.rglr_profit_amt, mtmk.rglr_profit_amt, rtk.rglr_profit_amt) as rglr_profit_amt,

    coalesce(cf.rglr_sale_amt_cpn, ds.rglr_sale_amt_cpn, mtmk.rglr_sale_amt_cpn, rtk.rglr_sale_amt_cpn) as rglr_sale_amt_cpn,

    coalesce(cf.rglr_sale_vat_amt_cpn, ds.rglr_sale_vat_amt_cpn, mtmk.rglr_sale_vat_amt_cpn, rtk.rglr_sale_vat_amt_cpn) as rglr_sale_vat_amt_cpn,

    coalesce(cf.rglr_sale_qty_cpn, ds.rglr_sale_qty_cpn, mtmk.rglr_sale_qty_cpn, rtk.rglr_sale_qty_cpn) as rglr_sale_qty_cpn,

    coalesce(cf.rglr_profit_amt_cpn, ds.rglr_profit_amt_cpn, mtmk.rglr_profit_amt_cpn, rtk.rglr_profit_amt_cpn) as rglr_profit_amt_cpn,

    coalesce(cf.added_tmsp, ds.added_tmsp, mtmk.added_tmsp, rtk.added_tmsp) as added_tmsp

from cf

full join ds
    on cf.sku_idnt = ds.sku_idnt

full join mtmk
    on coalesce(cf.sku_idnt, ds.sku_idnt) = mtmk.sku_idnt

full join rtk
    on coalesce(cf.sku_idnt, ds.sku_idnt, mtmk.sku_idnt) = rtk.sku_idnt

{% if is_incremental() %}

where coalesce(
    cf.added_tmsp,
    ds.added_tmsp,
    mtmk.added_tmsp,
    rtk.added_tmsp
) > (
    select coalesce(max(added_tmsp), '1900-01-01'::timestamp_ltz)
    from {{ this }}
)

{% endif %}