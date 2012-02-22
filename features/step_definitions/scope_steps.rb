module SectionLocator
  def within_parent(content, elements = ['*'], &block)
    expr = %(//*[(#{elements.join('|')})/descendant-or-self::*[contains(., "#{content}")]])
    within(:xpath, expr, &block)
  end
end

World(SectionLocator)

sections = %w(h1 h2 h3 h4 h5 h6 legend caption)

When /^(.*) in the "([^\"]*)" section$/ do |action, title|
  within_parent(title, sections) do
    step(action)
  end
end

When /^(.*) in the "([^\"]*)" section:$/ do |action, title, table|
  within_parent(title, sections) do
    step("#{action}:", table)
  end
end
