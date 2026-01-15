-- models/staging/stg_philosophy.sql

-- Source: raw_philosophy table in DuckDB
-- Transformations: Renaming columns and casting types

with source as (
    select * from raw_philosophy
),

renamed as (
    select
        title,
        author,
        school as school_of_thought,
        {{ dbt_utils.generate_surrogate_key(['school']) }} as school_id,
        sentence_str as sentence_text,
        -- Cast publication date to integer, handling potential errors if necessary (though schema implies int)
        try_cast(original_publication_date as integer) as publication_year,
        corpus_edition_date,
        sentence_length as original_sentence_length_char,
        sentence_lowered,
        tokenized_txt,
        lemmatized_str,
        -- Enriched columns
        sentiment_score,
        sentence_word_count
    from source
)

select * from renamed
