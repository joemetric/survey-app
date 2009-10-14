class CreateNewAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.references :reply
      t.references :question
      t.text :answer
      t.timestamps
    end
  end

  def self.down
  end
end
