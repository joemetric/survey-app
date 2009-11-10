class CreateSurveyPricings < ActiveRecord::Migration
  def self.up
    create_table :survey_pricings do |t|
      t.integer :survey_id,          :limit => 11
      t.integer :package_pricing_id, :limit => 11
      t.timestamps
    end
  end

  def self.down
    drop_table :survey_pricings
  end
end
