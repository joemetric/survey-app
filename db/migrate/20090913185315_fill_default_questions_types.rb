class FillDefaultQuestionsTypes < ActiveRecord::Migration
  def self.up
    QuestionType.create({ :name => "Short Text Response", :field_type => "text_area" })
    QuestionType.create({ :name => "Multiple Choice", :field_type => "check_box" })
    QuestionType.create({ :name => "Photo Upload", :field_type => "file_field" })
  end

  def self.down
  end
end
