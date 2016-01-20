module RecurringJob
  def reenqueue_job
    yield
  ensure
    enqueue_next_run
  end

  def enqueue_next_run
    # This is disgusting but Delayed::Job has no decent way to query outstanding jobs
    # We don't want to enqueue next weeks job more than once if it has to retry due to failures
    if Delayed::Job.where(["handler like ? and run_at > ?", "%#{name}%", DateTime.now.utc]).empty?
      Delayed::Job.enqueue self, { :priority => 5, :run_at => next_run_date }
    end
  end
end
