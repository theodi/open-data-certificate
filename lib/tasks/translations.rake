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

  # Translation Steps
  #
  # Start with
  # surveys/definition/questionnaire.general.xml
  # surveys/definition/questionnaire.jurisdiction.GB.xml
  #
  # ] rake surveys/generated/surveyor/odc_questionnaire.GB.rb
  #
  # generates:
  # surveys/generated/surveyor/odc_questionnaire.GB.rb
  # surveys/translations/questionnaire.general.en.yml
  # surveys/generated/translations/questionnaire.jurisdiction.GB.yml
  #
  # ] rake surveys/translations/questionnaire.jurisdictions.en.yml
  #
  # merges everything in surveys/generated/translations/* to become
  # surveys/translations/questionnaire.jurisdictions.en.yml
  #
  # The two files
  # surveys/translations/questionnaire.general.en.yml
  # surveys/translations/questionnaire.jurisdictions.en.yml
  #
  # are the Transifex source files and can be pushed to Transifex.
  #
  # ] rake translations:pull[CS]
  #
  # can then be used to pull down Czech translations, for example.

  JURISDICTION_LANGS = YAML.load_file('surveys/translations/jurisdiction_languages.yml')
  JURISDICTIONS = JURISDICTION_LANGS.keys

  SURVEY_DSL_FILES = JURISDICTIONS.map {|j| "surveys/generated/surveyor/odc_questionnaire.#{j}.rb" }
  SOURCE_JURISDICTION_FILES = Rake::FileList["surveys/generated/translations/questionnaire.jurisdiction.*.yml"]

  file 'surveys/translations/questionnaire.jurisdictions.en.yml' => SOURCE_JURISDICTION_FILES do |t|
    Translations::Merge.merge(t.name, t.prerequisites)
  end

  rule %r{surveys/generated/surveyor/odc_questionnaire\.[A-Z]{2}\.rb} => [
    ->(file_name){
      jurisdiction = jurisdiction_from_file_name(file_name)

      Rake::FileList[
        "surveys/definition/questionnaire.general.xml",
        "surveys/definition/questionnaire.jurisdiction.#{jurisdiction}.xml"
      ]
    }
  ] do |t|
    _, jurisdiction_file = t.prerequisites
    check_saxon_present!
    sh "saxon -s:#{jurisdiction_file} -xsl:surveys/transform/surveyor.xsl -o:surveys/not-made.xml"
    Rake::Task['surveys/translations/questionnaire.jurisdictions.en.yml'].invoke
  end

  desc 'Regenerate all DSL files for Surveyor. Take a look at surveyor:build_changed_survey as the next step.'
  task build_survey_dsl_files: SURVEY_DSL_FILES

  task :pull, [:jurisdiction] do |t, args|
    jurs = args.jurisdiction

    unless JURISDICTIONS.include?(jurs)
      fail "valid jurisdictions are #{JURISDICTIONS.join(', ')}"
    end

    langs = JURISDICTION_LANGS[jurs] - ['en']

    Rake::Task["surveys/generated/surveyor/odc_questionnaire.#{jurs}.rb"].invoke
    sh "tx pull -l #{langs.join(',')} --minimum-perc=1" if langs.any?
  end

  task :check_duplicates => :environment do
    translations = I18n.translate('.', locale: :en)
    translations.delete(:surveyor)
    indexed_translations = hash_translations_by_value(translations, {}, '')
    duplicate_translations = Hash[indexed_translations.select { |k, v| v.size > 1 }]

    duplicate_translations.each do |text, keys|
      puts "\e[31m#{text}\e[0m"
      keys.each do |key|
        puts "  #{key}"
      end
      puts "\n"
    end
  end
end

def jurisdiction_from_file_name(file_name)
  file_name[/([A-Za-z]{2})\.rb\z/, 1].upcase
end

def hash_translations_by_value(translations, result, namespace)
  translations.reduce(result) do |memo, (k,v)|
    if v.is_a?(String)
      memo[v] = [] unless memo.has_key?(v)
      memo[v] << "#{namespace}.#{k}"
    elsif v.is_a?(Hash)
      hash_translations_by_value(v, memo, "#{namespace}.#{k}")
    end

    memo
  end
end

def quiet
  stdout = $stdout.clone
  $stdout.reopen File.open('/dev/null', 'w')
  return yield
ensure
  $stdout.reopen stdout
end

def check_saxon_present!
    saxon = %x{which saxon}
    fail <<-BYE unless saxon.present?
The XSLT processor saxon needs to be installed

  brew install saxon

Should work on OSX or on Ubuntu/Debian

  apt-get install libsaxon-java default-jre

    BYE
end
