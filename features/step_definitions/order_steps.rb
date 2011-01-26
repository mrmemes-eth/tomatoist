Then /^(?:|I )should see the following list:$/ do |table|
  table.raw.each_with_index do |content, row|
    page.should have_xpath("//li[#{row+1}]/descendant-or-self::*[contains(normalize-space(.), '#{content.first}')]")
  end
end
