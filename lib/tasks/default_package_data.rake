# This RAKE task will load the Default Package Data
# rake db:load_default_package
namespace :survey do
  namespace :db do
    desc "Load Default Package Data"
    task :default_packages => :environment do
     if [PackageQuestionType.all, Package.all, PackagePricing.all, PackageLifetime.all].flatten.blank?
       
       puts 'Adding Different Question Types that will used during Survey creation....'
       # Adding Pre-Defined Question Types (As shown in Mock-up Screens)
       PackageQuestionType.create(:name => 'Standard Questions', :info => 'T/F, MC, Free Text')
       PackageQuestionType.create(:name => 'Premium Questions', :info => 'Photo response, GPS location')
       PackageQuestionType.create(:name => 'Standard Demographic Restrictions', :info => 'Profile data, Time')
       PackageQuestionType.create(:name => 'Premium Demographic Restrictions', :info => 'Location, Previous survey respones')
       
       # Default Pricing Plan data collected from http://projects.allerin.com/issues/show/572#change-216
        puts 'Adding Default Package....'
        package = Package.create(:name => 'Default', :code => 'default', :base_cost => 50, :total_responses => 20)
        
        default_package_pricings = [
          {:package_question_type_id => 1, :total_questions => 4, :standard_price => 1, :normal_price => 1.50},
          {:package_question_type_id => 2, :total_questions => 3, :standard_price => 1.50, :normal_price => 2.00},
          {:package_question_type_id => 3, :total_questions => 2, :standard_price => 3, :normal_price => 4},
          {:package_question_type_id => 4, :total_questions => 1, :standard_price => 5, :normal_price => 6}
        ]
        
        puts 'Adding Default Package Pricings...'
        default_package_pricings.each {|dp| package.pricings.create(dp) }
        
        payouts = [
          {:package_question_type_id => 1, :amount => 0.50},
          {:package_question_type_id => 2, :amount => 0.75},
          {:package_question_type_id => 3, :amount => 1.00},
          {:package_question_type_id => 4, :amount => 2.50}
        ]
        
        puts 'Adding Default Package\'s Payout Costs...'    
        payouts.each {|p| package.payouts.create(p)}
        
        puts 'Adding Package Lifetime Details...'
        # Create Package Lifetime for previously added packages
        Package.find(:all).each do |p| 
          PackageLifetime.create(:package_id => p.id, :cancelled => false, :validity_type_id => 1)
        end
        puts 'Execution Completed Successfully.'
      else
        puts 'This rake task have been already executed.' +
             'Related Database tables may contain default package data.'
      end
    end
  end
end