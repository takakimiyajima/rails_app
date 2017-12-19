class Faq < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: {
             analysis: {
                 tokenizer: {
                     kuromoji_user_dict: {
                         type: :kuromoji_tokenizer
                     },
                     ngram_tokenizer: {
                         type: 'nGram',
                         min_gram: '2',
                         max_gram: '3',
                         token_chars: ['letter', 'digit']
                     }
                 },
                 filter: {
                     # 指定した品詞を除外する
                     pos_filter: {
                         type: :kuromoji_part_of_speech,
                         stoptags: ['助詞-格助詞-一般', '助詞-終助詞']
                     },
                     greek_lowercase_filter: {
                         type: :lowercase,
                         language: :greek,
                     },
                 },
                 analyzer: {
                     kuromoji_analyzer: {
                         type: :custom,
                         tokenizer: :kuromoji_user_dict,
                         filter: [:kuromoji_baseform, :pos_filter, :greek_lowercase_filter, :cjk_width]
                     },
                     ngram_analyzer: {
                         tokenizer: :ngram_tokenizer,
                         filter: [:cjk_width]
                     }
                 }
             }
         } do
    mapping do
      indexes :staff,
              type: 'string',
              index: :analyzed,
              analyzer: :kuromoji_analyzer
      indexes :question,
              type: 'string',
              index: :analyzed,
              analyzer: :ngram_analyzer
      indexes :answer,
              type: 'string',
              index: :analyzed,
              analyzer: :ngram_analyzer
    end
  end

  Faq.first.__elasticsearch__.update_document
  Faq.import

  #include FaqSearchable
end
