Given /^(?:I )(?:am )?view(?:ing)? (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^(?:|I )should be viewing (.+)$/ do |page_name|
  step("I should be on #{page_name}")
end
