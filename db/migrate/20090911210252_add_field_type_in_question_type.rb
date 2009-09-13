class AddFieldTypeInQuestionType < ActiveRecord::Migration
  def self.up
    add_column :question_types, :field_type, :string
  end

  def self.down
    remove_column :question_types, :field_type
  end
end
