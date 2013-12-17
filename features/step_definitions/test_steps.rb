Given /^I am on the homepage$/ do
  visit '/'
end

Given /^browserstack tunnel is running$/ do
  assert `ps -ef | awk '/BrowserStackTunnel.*,#{Capybara.server_port},/{print $2}'`.scan(/\d+/).length > 1
  #GOTCHA: looking for 2, because the ps process also creates a process with this string in it.
end
Given /^Capybara is not :rack_test$/ do
  assert Capybara.current_driver != :rack_test
end
