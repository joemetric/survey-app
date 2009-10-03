class CreatePackageQuestionTypes < ActiveRecord::Migration
  def self.up
    create_table :package_question_types do |t|
      t.string :name
      t.string :info
      t.timestamps
    end
    # Adding Pre-Defined Question Types (As shown in Mock-up Screens)
    PackageQuestionType.create(:name => 'Standard Questions', :info => 'T/F, MC, Free Text')
    PackageQuestionType.create(:name => 'Premium Questions', :info => 'Photo response, GPS location')
    PackageQuestionType.create(:name => 'Standard Demographic Restrictions', :info => 'Profile data, Time')
    PackageQuestionType.create(:name => 'Premium Demographic Restrictions', :info => 'Location, Previous survey respones')
  end

  def self.down
    drop_table :package_question_types
  end
end
