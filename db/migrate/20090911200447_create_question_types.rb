class CreateQuestionTypes < ActiveRecord::Migration
  def self.up
    create_table :question_types do |t|
      t.string :name
      t.timestamps
    end
    
    QuestionType.create({ :name => "Short Text Response" })
    QuestionType.create({ :name => "Multiple Choice" })
    QuestionType.create({ :name => "Photo Upload" })
    
  end

  def self.down
    drop_table :question_types
  end
end
