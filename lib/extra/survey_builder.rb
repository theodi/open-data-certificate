# for building surveys from delayed job
class SurveyBuilder < Struct.new(:dir, :basename)

  def perform
    survey_parsing = SurveyParsing.find_or_create_by_file_name("#{dir}/#{basename}")
    survey_parsing.md5 = Digest::MD5.hexdigest(file_contents)

    @changed = survey_parsing.changed? && survey_parsing.save

    record_event "SurveyBuilder: #{dir}/#{basename} - #{@changed ? 'building' : 'skipping '} - #{survey_parsing.md5}"

    parse_file(file).set_expired_certificates if @changed

    @changed
  end

  def build_priority
    stub = ParseStub.new
    stub.instance_eval(file_contents)
    return 1 if stub.name == Survey::DEFAULT_ACCESS_CODE
    return 2 if stub.args[0][:status].to_s == 'beta'
    return 3
  end

  # Parse code taken from surveyor to allow the survey object to be returned
  def parse_file(filename, options={})
    str = File.read(filename)
    Surveyor::Parser.ensure_attrs
    Surveyor::Parser.options = {filename: filename}.merge(options)
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
