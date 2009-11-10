class CreateSurveyPackages < ActiveRecord::Migration
  def self.up
    create_table :survey_packages do |t|
      t.integer :survey_id, :limit => 11
      t.string  :name,      :limit => 255
      t.string  :code,      :limit => 255
      t.float   :base_cost
      t.integer :total_responses
    end
  end

  def self.down
    drop_table :survey_packages
  end
end
