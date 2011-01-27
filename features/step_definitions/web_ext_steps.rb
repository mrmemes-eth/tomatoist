Given /^(?:I )(?:am )?view(?:ing)? (.+)$/ do |page_name|
  visit path_to(page_name)
end
