class SurveyParsing < ActiveRecord::Base
  # Placeholder to track the MD5 of a survey file, so the deployment rake task can determine whether the survey has been
  # updated or not.
  attr_accessible :file_name

  def jurisdiction
    match = file_name.match(/\.(..)\.rb$/)
    match ? match[1] : 'GB'
  end

  def translation_files
    files = JURISDICTION_LANGS[jurisdiction].map do |lang|
      %w[general jurisdictions].map {|section| "surveys/translations/questionnaire.#{section}.#{lang}.yml" }
    end
    files.flatten
  end

  def translation_contents
    translation_files.map {|file| File.read(Rails.root.join(file)) }.join
  end

  def compute_digest!
    file_contents = File.read(Rails.root.join(file_name))
    self.md5 = Digest::MD5.hexdigest(file_contents + translation_contents)
  end
end
