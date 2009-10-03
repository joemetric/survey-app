class AddDefaultPackage < ActiveRecord::Migration
  def self.up
    
    # Default Pricing Plan data collected from http://projects.allerin.com/issues/show/572#change-216
    
    package = Package.create(:name => 'Default', :code => 'default', :base_cost => 50, :total_responses => 20)
    
    default_package_pricings = [
      {:package_question_type_id => 1, :total_questions => 4, :standard_price => 1, :normal_price => 1.50},
      {:package_question_type_id => 2, :total_questions => 3, :standard_price => 1.50, :normal_price => 2.00},
      {:package_question_type_id => 3, :total_questions => 2, :standard_price => 3, :normal_price => 4},
      {:package_question_type_id => 4, :total_questions => 1, :standard_price => 5, :normal_price => 6}
    ]
    
    default_package_pricings.each do |dp|
      package.pricings.create(dp)
    end
    
    payouts = [
      {:package_question_type_id => 1, :amount => 0.50},
      {:package_question_type_id => 2, :amount => 0.75},
      {:package_question_type_id => 3, :amount => 1.00},
      {:package_question_type_id => 4, :amount => 2.50}
    ]
   
    payouts.each do |p|
      package.payouts.create(p)
    end
  end

  def self.down
    execute('DELETE FROM packages;');
    execute('DELETE FROM package_pricings;');
    execute('DELETE FROM payouts;');
  end
  
end