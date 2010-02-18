# rake features FEATURE=features/packages.feature
 
Given /I am visiting the Pricing Administration Page/i do
   @admin = Admin.new({ :email => "admin@joemetric.com", :name => "Admin", :login => "admin", :password => "1dkgi341", :password_confirmation => "1dkgi341" })
   @admin.save
   visit '/admin/admin_session/new'
   fill_in("admin_session_login", :with => @admin.login)
   fill_in("admin_session_password", :with => @admin.password)
   click_button("admin_session_submit")
   package = Package.new(:name => "Default", :code => "default")
   package.save
   visit '/admin/packages'
end

And /Pricing Administration Page should have link as (.*)/ do |link|
  response.should have_selector('a', :content => link)
end

When /I click on (.*)$/ do |link|
  click_link link
end

Then /It should display Create New Package Form/ do
  visit '/admin/packages/new'
end

When /I submit package form with Name: (.*), Code: (.*)/ do |name, code|
  post "/admin/packages/create", :package => {:name => name, :code => code}
end

Then /It should save package details Name: (.*), Code: (.*)/ do |name, code|
  package = Package.new(:name => name, :code => code)
  Package.exists?(:name => name).should be true
end

And /Redirect to Pricing Administration Page/ do 
  visit '/admin/packages'
end

Then /It should not save package details Name: (.*), Code: (.*)/ do |name, code|
  package = Package.new(:name => name, :code => code)
  Package.exists?(:name => name).should be false
end