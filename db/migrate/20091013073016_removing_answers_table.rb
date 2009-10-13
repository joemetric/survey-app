class RemovingAnswersTable < ActiveRecord::Migration
  def self.up
    drop_table :answers
  end

  def self.down
    create_table :answers do |t|
      t.references :question
      t.references :user
      t.string :question_type
      t.text :answer_string
      t.string :answer_file
      t.references :picture
      t.timestamps
    end
  end
end
