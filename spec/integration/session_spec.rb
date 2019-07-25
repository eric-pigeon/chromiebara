skip = []
Capybara::SpecHelper.run_specs TestSessions::Chromiebara, 'Chromiebara', capybara_skip: skip do |example|
  # case example.metadata[:full_description]
  # when /#obscured\? should work in nested iframes/
  #   pending 'frame support for #obscured is not implemented'
  # end
end
