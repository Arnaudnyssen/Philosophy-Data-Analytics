-- models/marts/dim_schools.sql

with stg_philosophy as (
    select * from {{ ref('stg_philosophy') }}
),

schools as (
    select distinct
        school_id,
        school_of_thought
    from stg_philosophy
)

select * from schools
