class CreatePackageQuestionTypes < ActiveRecord::Migration
  def self.up
    create_table :package_question_types do |t|
      t.string :name
      t.string :info
      t.timestamps
    end
  end

  def self.down
    drop_table :package_question_types
  end
end
