Given /^I am visiting the Charity Organization Administration Page$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^Charity Organization Administration Page should have button as Create a New Organization$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^It should display Create a New Organization Form$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I submit organization form with Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: 12345, Phone: 1234567890, Email: testorg@orgdomain\.com, Tax Status: Approved, Tax ID: 12321$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^It should save package details Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: 12345, Phone: 1234567890, Email: testorg@orgdomain\.com, Tax Status: Approved, Tax ID: 12321$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I submit package form with Name: , Address1: , City1: , State1: , ZipCode1: , Phone: , Email: , Tax Status: , Tax ID:$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^It should not save package details Name: , Address1: , City1: , State1: , ZipCode1: , Phone: , Email: , Tax Status: , Tax ID:$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I submit package form with Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: sdfasdas, Phone: 12233234567890, Email: testorgATorgdomainDOTcom, Tax Status: Approved, Tax ID: charbutneedint$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^It should not save package details Name: Test Organization, Address1: Test Address, City1: Test City, State1: CA, ZipCode1: sdfasdas, Phone: 12233234567890, Email: testorgATorgdomainDOTcom, Tax Status: Approved, Tax ID: charbutneedint$/ do
  pending # express the regexp above with the code you wish you had
end
