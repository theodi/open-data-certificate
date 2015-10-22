require 'fileutils'
require 'translations'

namespace :translations do
  task :update do
    translation_sheet = ENV['TRANSLATIONS']
    country_code = ENV['COUNTRY']
    lang_code = ENV['LANG']
    fail <<-BYE unless [translation_sheet, country_code, lang_code].all? { |v| v.present? }
Usage rake translations:update TRANSLATIONS=spreadsheet.xlsx COUNTRY=BR LANG=pt
    BYE
    saxon = %x{which saxon}
    fail <<-BYE unless saxon.present?
saxon needs to be installed

  brew install saxon

Should work on OSX
    BYE

    converter = quiet { Translations::SpreadsheetConverter.new(translation_sheet) }
    base_path = 'translations/temp'
    FileUtils.mkdir_p "prototype/#{base_path}"
    legal_path = "#{base_path}/#{lang_code}.legal.txt"
    main_path = "#{base_path}/#{lang_code}.main.txt"
    converter.extract('Legal', "prototype/#{legal_path}")
    converter.extract('Main', "prototype/#{main_path}")
    sh "saxon -s:prototype/jurisdictions/certificate.#{country_code}.xml -xsl:prototype/auto-translate.xsl -o:prototype/jurisdictions/certificate.#{country_code}.xml translationFile=#{legal_path}"
    sh "saxon -s:prototype/translations/certificate.en.xml -xsl:prototype/auto-translate.xsl -o:prototype/translations/certificate.#{lang_code}.xml translationFile=#{main_path}"
    sh "saxon -s:prototype/translations/certificate.#{lang_code}.xml -xsl:prototype/mark-lang.xsl -o:prototype/translations/certificate.#{lang_code}.xml lang=#{lang_code}"
    sh "saxon -s:prototype/jurisdictions/certificate.#{country_code}.xml -xsl:prototype/mark-lang.xsl -o:prototype/jurisdictions/certificate.#{country_code}.xml lang=#{lang_code}"
    FileUtils.mkdir_p "prototype/temp"
    sh "saxon -s:prototype/jurisdictions/ -xsl:prototype/surveyor.xsl -o:prototype/temp"
  end

  # translation steps
  # start with
  # surveys/definition/questionnaire.general.xml
  # surveys/definition/questionnaire.jurisdiction.GB.xml
  # generates:
  # surveys/generated/surveyor/odc_questionnaire.GB.rb
  # surveys/translations/questionnaire.general.en.yml
  # surveys/translations/questionnaire.jurisdiction.GB.en.yml
  # push these to transifex
  # pull translations to other languages
  # merge translation yml files
  # english will be in questionnaire spec but translation file would be of form
  # surveys/generated/surveyor/odc_questionnaire.GB.en.yml
  # so in other cases:
  # surveys/generated/surveyor/odc_questionnaire.CZ.cs.yml
  # surveys/generated/surveyor/odc_questionnaire.CZ.en.yml

  SURVEY_LOCALE_FILES = Rake::FileList['surveys/generated/locales/surveys.*.yml']

  JURISDICTION_LANGS = YAML.load_file('surveys/translations/jurisdiction_languages.yml')
  JURISDICTIONS = JURISDICTION_LANGS.keys

  rule %r{surveys/generated/locales/surveys\.[a-z]{2}\.yml} => [
    ->(file_name){
      locale = locale_from_file_name(file_name)

      Rake::FileList[
        "surveys/translations/questionnaire.general.#{locale}.yml",
        "surveys/translations/questionnaire.jurisdiction.*.#{locale}.yml"
      ]
    }
  ] do |t|
    Translations::Merge.merge(t.name, t.prerequisites)
  end

  task build_survey_locales: SURVEY_LOCALE_FILES

  JURISDICTIONS.each do |jurs|
    file "surveys/generated/surveyor/odc_questionnaire.#{jurs}.rb" => %W[
        surveys/definition/questionnaire.general.xml
        surveys/definition/questionnaire.jurisdiction.#{jurs}.xml] do |t|
      general, jurisdiction = t.prerequisites
      sh "saxon -s:#{jurisdiction} -xsl:surveys/transform/surveyor.xsl -o:surveys/not-made.xml"
    end
  end

  task :pull, [:jurisdiction] do |t, args|
    unless JURISDICTIONS.include?(args.jurisdiction)
      raise ArgumentError, "valid jurisdictions are #{JURISDICTIONS.join(', ')}"
    end
    jurs = args.jurisdiction
    langs = JURISDICTION_LANGS[jurs]
    langs_except_en = langs - %w[en]
    Rake::Task["surveys/generated/surveyor/odc_questionnaire.#{jurs}.rb"].invoke
    if langs_except_en.any?
      sh "tx pull -l #{langs_except_en.join(',')} --minimum-perc=1"
    end
    langs.each do |lang|
      translation = "surveys/generated/locales/surveys.#{lang}.yml"
      Rake::Task[translation].invoke
    end
  end
end

def locale_from_file_name(file_name)
  file_name[/([A-Za-z]{2})\.yml\z/, 1].downcase
end

def quiet
  stdout = $stdout.clone
  $stdout.reopen File.open('/dev/null', 'w')
  return yield
ensure
  $stdout.reopen stdout
end
