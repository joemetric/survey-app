namespace :db do
  desc "Load Default Questions Types"
  task :load_default_questions_types => :environment do
    puts "Adding default questions types"
    [ { :name => "Short Text Response", :field_type => "text_area" },
      { :name => "Multiple Choice", :field_type => "check_box"},
      { :name => "Photo Upload", :field_type => "file_field"}
    ].each do |qt_attributes|
      qt = QuestionType.new(qt_attributes)
      status = qt.save
      puts "- #{qt.name}: #{(status) ? "OK" : "Failed" }"
    end
  end
end
