require File.join(Rails.root, 'lib/tasks/overloading_rake_tasks.rb')

override_task :surveyor => :environment do
  # overloading the default 'surveyor' task to update the SurveyParsing record
  Rake::Task["surveyor:original"].invoke

  survey_parsing = SurveyParsing.find_or_create_by_file_name(ENV['FILE'])
  raise "Could not record the md5 hash for #{ENV['FILE']}" unless survey_parsing.persisted?
  survey_parsing.update_attribute :md5, Digest::MD5.hexdigest(File.read(File.join(Dir.pwd, ENV['FILE'])))
end

namespace :surveyor do
  desc 'Iterate all surveys and parse those that have changed since last build (Specify DIR=your/surveys to choose folder other than `surveys`)'
  task :build_changed_surveys => :environment do
    dir = ENV['DIR'] || 'surveys'
    # Compares the MD5 of each file in the 'surveys' folder with the stored hash in the file's SurveyParsing record
    files = Dir.entries(File.join(Rails.root, dir)).select { |file| file =~ /.*\.rb/ }

    files.each do |file|
      ENV['FILE'] = File.join(dir, file)

      md5 = Digest::MD5.hexdigest(File.read(File.join(Dir.pwd, ENV['FILE'])))
      survey_parsing = SurveyParsing.find_or_create_by_file_name(ENV['FILE'])

      if survey_parsing.md5 != md5
        Rake::Task["surveyor"].invoke
        ::Rake::Task.tasks.each { |t| t.reenable } # re-enabling *all* Rake tasks... is there a better way of re-enabling dependencies?
      else
        puts "--- #{file} not changed"
      end
    end

  end
end


namespace :odc do

  desc "remove (12h) old and unclaimed questionnaires"
  task :purge_questionnaires => :environment do

    purge_before = Time.now - 12.hours

    rs = ResponseSet.
      where(user_id: nil). # unclaimed response_sets
      where(ResponseSet.arel_table[:updated_at].lt(purge_before)).
      destroy_all

  end
end
