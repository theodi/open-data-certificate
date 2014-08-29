module GenerateStats

  def self.perform
    Stat.generate_published
    Stat.generate_all
    Delayed::Job.enqueue GenerateStats, { :priority => 5, :run_at => 1.day.from_now }
  end

end
