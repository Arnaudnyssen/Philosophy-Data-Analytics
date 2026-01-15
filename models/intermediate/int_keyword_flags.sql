-- models/intermediate/int_keyword_flags.sql

-- Logic: Create binary flags for keywords: 'god', 'reason', 'science', 'nature'

with stg_philosophy as (
    select * from {{ ref('stg_philosophy') }}
),

flagged as (
    select
        *,
        -- Case insensitive search for keywords
        case when lower(sentence_text) like '%god%' then 1 else 0 end as has_god,
        case when lower(sentence_text) like '%reason%' then 1 else 0 end as has_reason,
        case when lower(sentence_text) like '%science%' then 1 else 0 end as has_science,
        case when lower(sentence_text) like '%nature%' then 1 else 0 end as has_nature
    from stg_philosophy
)

select * from flagged
