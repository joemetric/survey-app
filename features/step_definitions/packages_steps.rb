# rake features FEATURE=features/packages.feature
 
Given /I am on Pricing Administration Page/i do |login|
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
  package = create_package(name, code)
  package.save.should be_true
end

And /Redirect to Pricing Administration Page/ do 
  visit '/admin/packages'
end

Then /It should not save package details Name: (.*), Code: (.*)/ do |name, code|
  package = create_package(name, code)
  package.save.should be_false
end

def create_package(name, code)
  Package.create(:name => name, :code => code)
end