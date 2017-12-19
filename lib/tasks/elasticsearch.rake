namespace :elasticsearch do
  desc 'Elasticsearch のindex作成' #taskの説明
  task :create_index => :environment do
    Faq.create_index!
  end

  desc 'Faq を Elasticsearch に登録'
  task :import_faq => :environment do
    Faq.import
  end

end
