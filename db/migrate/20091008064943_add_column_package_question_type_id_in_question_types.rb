class AddColumnPackageQuestionTypeIdInQuestionTypes < ActiveRecord::Migration
  def self.up
    add_column :question_types, :package_question_type_id, :integer
    execute('UPDATE question_types SET package_question_type_id = 1 WHERE id IN (1, 2);');
    execute('UPDATE question_types SET package_question_type_id = 2 WHERE id = 3;');
  end

  def self.down
    remove_column :question_types, :package_question_type_id
  end
end
