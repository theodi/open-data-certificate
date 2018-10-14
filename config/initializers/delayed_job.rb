Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.default_log_level = 'debug'.freeze
Delayed::Worker.max_run_time = 8.hours
Delayed::Worker.max_attempts = 1
Delayed::Worker.delay_jobs = false