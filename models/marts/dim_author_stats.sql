-- models/marts/dim_author_stats.sql

-- Granularity: Author, School
-- Metrics: Avg sentiment, Avg sentence length, Total sentences

with stg_philosophy as (
    select * from {{ ref('stg_philosophy') }}
),

-- Tokenize text to calculate vocabulary richness
tokenized as (
    select 
        author, 
        unnest(str_split(lower(sentence_text), ' ')) as word 
    from stg_philosophy
),

vocab_stats as (
    select 
        author, 
        count(distinct word) as unique_words,
        count(word) as total_words_tokenized
    from tokenized
    group by 1
),

aggregated as (
    select
        p.author,
        count(*) as total_sentences,
        avg(p.sentiment_score) as avg_sentiment_score,
        avg(p.sentence_word_count) as avg_sentence_length,
        -- Sentiment Category
        case 
            when avg(p.sentiment_score) > 0.085 then 'Optimistic'
            when avg(p.sentiment_score) < 0.056 then 'Pessimistic'
            else 'Neutral'
        end as sentiment_category
    from stg_philosophy p
    group by 1
)

select 
    a.*,
    v.unique_words,
    -- Vocabulary Richness: Guiraud Index (Unique words / Sqrt(Total words))
    v.unique_words::DOUBLE / sqrt(v.total_words_tokenized) as vocabulary_richness
from aggregated a
left join vocab_stats v on a.author = v.author
