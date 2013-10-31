# for building surveys from delayed job
class SurveyBuilder < Struct.new(:dir, :basename)

  def perform
    puts "--- Building #{dir}, #{basename}" unless Rails.env.test?

    survey_parsing = SurveyParsing.find_or_create_by_file_name("#{dir}/#{basename}")
    survey_parsing.md5 = Digest::MD5.hexdigest(file_contents)

    @changed = survey_parsing.changed? && survey_parsing.save

    parse_file(file).schedule_expiries if @changed

    puts " ^---> #{@changed ? 'Built' : 'Skipped'}" unless Rails.env.test?

    @changed
  end

  def default_survey?
    stub = ParseStub.new
    stub.instance_eval(file_contents)
    stub.name == Survey::DEFAULT_ACCESS_CODE
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

  # tracking events for debugging

  def before(job)
    record_event "starting - #{basename}"
  end

  def after(job)
    record_event "finished - #{basename}"
  end

  def success(job)
    record_event "success - #{basename}"
  end

  def error(job, exception)
    record_event "error - #{basename}"
    Airbrake.notify(exception) if defined? Airbrake
  end

  private

  def record_event message
    DevEvent.create message: message
  end

  # a stub parser to collect the name of the survey
  class ParseStub
    attr_reader :name
    def survey(name, *args, &block)
      # match surveyor name->access_code
      @name = name.to_s.downcase.gsub(/[^a-z0-9]/,"-").gsub(/-+/,"-").gsub(/-$|^-/,"")
    end
  end

  def file_contents
    File.read(file)
  end

  def file
    Rails.root.join(dir,basename)
  end

end
