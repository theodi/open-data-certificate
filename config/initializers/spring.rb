if defined?(Spring) && defined?(FactoryGirl)
  Spring.after_fork do
    FactoryGirl.reload
  end
end