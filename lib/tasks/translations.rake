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
  # surveys/odc_questionnaire.GB.rb
  # surveys/translations/source/questionnaire.general.yml
  # surveys/translations/source/questionnaire.jurisdiction.GB.yml
  # push these to transifex
  # pull translations to other languages
  # merge translation yml files
  # english will be in questionnaire spec but translation file would be of form
  # surveys/translations/odc_questionnaire.GB.en.yml
  # so in other cases:
  # surveys/translations/odc_questionnaire.CZ.cs.yml
  # surveys/translations/odc_questionnaire.CZ.en.yml
  # and if multiple locale differences are required per language
  # surveys/translations/odc_questionnaire.NO.nb_NO.yml
  # surveys/translations/odc_questionnaire.NO.nn_NO.yml
  # surveys/translations/odc_questionnaire.NO.en.yml
end

def quiet
  stdout = $stdout.clone
  $stdout.reopen File.open('/dev/null', 'w')
  return yield
ensure
  $stdout.reopen stdout
end
