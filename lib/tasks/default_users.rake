namespace :survey do
  namespace :db do
    desc "Load Default Users"
    task :default_users => :environment do
      if Admin.all.blank?
        puts "Adding default administrative user"
        @admin = Admin.new({ :email => "admin@joemetric.com", :name => "Admin", :login => "admin", :password => "1dkgi341", :password_confirmation => "1dkgi341" })
        if @admin.save
          puts "Admin added. Login: admin"
        else
          puts "Error occured. Please check."
        end
      end
      # User
       if User.all.blank?
          puts "Adding default administrative user"
          @user = User.new({ :email => "test@joemetric.com", :name => "Test", :login => "Test", :password => "test", :password_confirmation => "test" })
          if @user.save
            puts "User added. Login: test"
          else
            puts "Error occured. Please check."
          end
        end
    end
  end
end