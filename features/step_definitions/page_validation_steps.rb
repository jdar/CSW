Given(/^I should see "(.*)"$/) do | str |
  assert_equal page.body, str
end
