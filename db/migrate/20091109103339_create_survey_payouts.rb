class CreateSurveyPayouts < ActiveRecord::Migration
  def self.up
    create_table :survey_payouts do |t|
      t.integer :survey_id, :limit => 11
      t.integer :payout_id, :limit => 11
      t.timestamps
    end
  end

  def self.down
    drop_table :survey_payouts
  end
end
