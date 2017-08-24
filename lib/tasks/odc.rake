require File.join(Rails.root, 'lib/tasks/overloading_rake_tasks.rb')

override_task :surveyor => :environment do
  # overloading the default 'surveyor' task to update the SurveyParsing record
  Rake::Task["surveyor:original"].invoke

  survey_parsing = SurveyParsing.find_or_create_by_file_name(ENV['FILE'])
  raise "Could not record the md5 hash for #{ENV['FILE']}" unless survey_parsing.persisted?
  survey_parsing.update_attribute :md5, Digest::MD5.hexdigest(File.read(File.join(Dir.pwd, ENV['FILE'])))
end

namespace :surveyor do
  task :generate, [:jurisdiction] do |t, args|
    jurs = args.jurisdiction
    unless jurs
      raise ArgumentError, "use surveyor:generate[jurisdiction] to specify jurisdiction"
    end
    Rake::Task["surveys/generated/surveyor/odc_questionnaire.#{jurs}.rb"].invoke
  end

  task :update, [:jurisdiction] do |t, args|
    jurs = args.jurisdiction
    unless jurs
      raise ArgumentError, "use surveyor:update[jurisdiction] to specify jurisdiction"
    end
    Rake::Task['translations:pull'].invoke(jurs)
    Rake::Task['surveyor:build'].invoke(jurs)
  end

  task :build, [:jurisdiction] => [:environment] do |t, args|
    jurs = args.jurisdiction
    unless jurs
      raise ArgumentError, "use surveyor:build[jurisdiction] to specify jurisdiction"
    end
    SurveyBuilder.new('surveys/generated/surveyor', "odc_questionnaire.#{jurs}.rb").perform
  end

  desc 'Iterate all surveys and parse those that have changed since last build (Specify DIR=your/surveys to choose folder other than `surveys/generated/surveyor`)'
  task :build_changed_surveys => :environment do
    dir = ENV['DIR'] || 'surveys/generated/surveyor'
    limit = (ENV['LIMIT'] || '10000').to_i

    files = Dir.entries(Rails.root.join(dir)).select { |file| file =~ /.*\.rb/ }

    files.each do |file|
      if limit > 0
        builder = SurveyBuilder.new(dir, file)

        limit -= 1 if builder.perform
      end
    end
  end

  desc  'build a survey only if file has changed'
  task :build_changed_survey => :environment do
    f_arg = ENV["FILE"]
    file = Rails.root.join f_arg.to_s
    raise "File does not exist: #{file}" if f_arg.nil? || !FileTest.exists?(file)

    # convert into the correct format for the survey builder
    base = File.basename(f_arg.to_s)
    dir = f_arg[0...f_arg.rindex(base)]

    builder = SurveyBuilder.new(dir, base)
    builder.perform
  end

  desc "queue up surveys to be built by delayed job"
  task :enqueue_surveys => :environment do
    DevEvent.create message: "surveyor:enqueue_surveys"

    dir = ENV['DIR'] || 'surveys/generated/surveyor'
    files = Dir.entries(Rails.root.join(dir)).select { |file| file =~ /.*\.rb/ }

    files.each do |file|
      builder = SurveyBuilder.new(dir, file)

      # build is prioritised by being default survey or beta status
      priority =  builder.build_priority

      Delayed::Job.enqueue builder, priority: priority, run_at: 5.minutes.from_now
    end

    DevEvent.create message: "surveyor:enqueued #{files.join(', ')}"
  end

end


namespace :odc do

  desc "Task to run when a new version of the app has been deployed"
  task :deploy => %w(surveyor:enqueue_surveys odc:purge_questionnaires) do
    ENV['TO'] = ENV['AIRBRAKE_ENV']
    if ENV['AIRBRAKE_CERTIFICATE_KEY']
      Rake::Task['airbrake:deploy'].invoke
    end
  end

  desc "remove (12h) old and unclaimed questionnaires"
  task :purge_questionnaires => :environment do

    purge_before = Time.now - 12.hours

    ResponseSet.
      where(user_id: nil). # unclaimed response_sets
      where(ResponseSet.arel_table[:updated_at].lt(purge_before)).
      destroy_all

  end

  task :generate_dataset_csv => :environment do
    Delayed::Job.enqueue CSVExport, { :priority => 5, :run_at => 10.minutes.from_now.utc }
  end
end
