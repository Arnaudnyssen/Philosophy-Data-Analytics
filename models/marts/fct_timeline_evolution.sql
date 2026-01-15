-- models/marts/fct_timeline_evolution.sql

-- Granularity: Author, Year
-- Metrics: Sum of keyword flags

with flags as (
    select * from {{ ref('int_keyword_flags') }}
),

aggregated as (
    select
        author,
        school_id,
        publication_year,
        count(*) as total_sentences,
        sum(has_god) as god_mentions,
        sum(has_reason) as reason_mentions,
        sum(has_science) as science_mentions,
        sum(has_nature) as nature_mentions,
        -- Normalized Metrics (Percentage of total sentences)
        sum(has_god) / count(*) as god_mentions_pct,
        sum(has_reason) / count(*) as reason_mentions_pct,
        sum(has_science) / count(*) as science_mentions_pct,
        sum(has_nature) / count(*) as nature_mentions_pct
    from flags
    where publication_year is not null
    group by 1, 2, 3
)

select * from aggregated
