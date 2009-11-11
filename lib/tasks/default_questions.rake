
# Please check spec/fixtures/question_types.yml before adding any new question type
namespace :survey do
  namespace :db do
    desc "Load Default Questions Types"
    task :questions_types => :environment do
      puts "Truncating question_types table..."
      ActiveRecord::Base.connection.execute('TRUNCATE question_types;');
      puts "Adding default questions types"
      [ { :name => "Short Text Response", :field_type => "text_area", :package_question_type_id => 1 },
        { :name => "Multiple Choice", :field_type => "check_box", :package_question_type_id => 1},
        { :name => "Photo Upload", :field_type => "file_field", :package_question_type_id => 2}
      ].each do |qt_attributes|
        qt = QuestionType.new(qt_attributes)
        status = qt.save
        puts "- #{qt.name}: #{(status) ? "OK" : "Failed" }"
      end
    end
  end
end