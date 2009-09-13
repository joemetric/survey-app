class FillDefaultQuestionsTypes < ActiveRecord::Migration
  def self.up
    # Be Aware:
    # When you run all the migrations for the first time, AR can't identify QuestionType as model, and it pressumes that create
    # is a migration method and raises an exception.
    # Running again without changing anything should solve the problem. 
    # But this wierd behaviour must be fixed. I'm searching for an answer. 
    QuestionType.create({ :name => "Short Text Response", :field_type => "text_area" })
    QuestionType.create({ :name => "Multiple Choice", :field_type => "check_box" })
    QuestionType.create({ :name => "Photo Upload", :field_type => "file_field" })
  end

  def self.down
  end
end
