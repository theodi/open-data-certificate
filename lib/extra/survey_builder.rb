# for building surveys from delayed job
class SurveyBuilder < Struct.new(:dir, :basename)

  def surveyor_override!
    require 'surveyor/parser'
    SurveyorParserSurveyTranslationMethods.module_eval do
      def parse_and_build(context, args, original_method, reference_identifier)
        dir = Surveyor::Parser.options[:filename].nil? ? Dir.pwd : File.dirname(Surveyor::Parser.options[:filename])
        # build, no change in context
        args[0].each do |k,v|
          case v
          when Hash
            trans = YAML::dump(v)
          when String
            translations = YAML::load_file(File.join(dir,v))
            trans = YAML::dump(translations[k.to_s])
          when :default
            trans = YAML::dump({})
          end
          context[:survey].translations << self.class.new(:locale => k.to_s, :translation => trans)
        end
      end
    end
  end

  def perform
    surveyor_override!

    survey_parsing = SurveyParsing.find_or_create_by_file_name("#{dir}/#{basename}")
    survey_parsing.md5 = Digest::MD5.hexdigest(file_contents)

    changed = survey_parsing.changed? && survey_parsing.save

    record_event "SurveyBuilder: #{dir}/#{basename} - #{changed ? 'building' : 'skipping '} - #{survey_parsing.md5}"

    if changed
      survey = parse_file
      survey.set_expired_certificates
    end

    changed
  end

  def build_priority
    stub = ParseStub.new
    stub.instance_eval(file_contents)
    return 1 if stub.name == Survey::DEFAULT_ACCESS_CODE
    return 2 if stub.args[0][:status].to_s == 'beta'
    return 3
  end

  # Parse code taken from surveyor to allow the survey object to be returned
  def parse_file(options={})
    str = File.read(file)
    Surveyor::Parser.ensure_attrs
    Surveyor::Parser.options = {filename: file}.merge(options)
    Surveyor::Parser.log[:source] = str
    Surveyor::Parser.rake_trace "\n"
    survey = Surveyor::Parser.new.parse(str)
    Surveyor::Parser.rake_trace "\n"
    survey
  end

  def error(job, exception)
    record_event "error - #{basename}"
    Airbrake.notify(exception) if defined? Airbrake
  end

  private

  def record_event message
    DevEvent.create message: message
    puts message unless Rails.env.test?
  end

  # a stub parser to collect the name of the survey
  class ParseStub
    attr_reader :name, :args
    def survey(name, *args, &block)
      # match surveyor name->access_code
      @name = name.to_s.downcase.gsub(/[^a-z0-9]/,"-").gsub(/-+/,"-").gsub(/-$|^-/,"")
      @args = args
    end
  end

  def file_contents
    File.read(file)
  end

  def file
    Rails.root.join(dir,basename)
  end

end
