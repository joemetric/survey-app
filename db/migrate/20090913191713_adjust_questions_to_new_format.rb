class AdjustQuestionsToNewFormat < ActiveRecord::Migration
  def self.up
    remove_column :questions, :text
    remove_column :questions, :question_type
    add_column :questions, :question_type_id, :integer
  end

  def self.down
    add_column :questions, :text, :string
    add_column :questions, :question_type, :string
    remove_column :questions, :questions_type_id
  end
end
