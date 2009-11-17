namespace :survey do
  namespace :payment do  
    desc "Executes paypal process that Refunds survey amount and Transfer payouts"
    task :start_paypal_process => :environment do
      PaypalProcessor.execute
    end
  end
end