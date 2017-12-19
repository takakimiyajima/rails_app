json.extract! faq, :id, :staff, :question, :answer, :created_at, :updated_at
json.url faq_url(faq, format: :json)
