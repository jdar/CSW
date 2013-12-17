Given(/^I should see "(.*)"$/) do | str |
  find("#p1").has_content?(str)
  #assert_equal page.body., str
end
