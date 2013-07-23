# for building surveys from delayed job
class SurveyBuilder < Struct.new(:dir, :basename)

  def perform
    puts "--- Building #{dir}, #{basename}"

    survey_parsing = SurveyParsing.find_or_create_by_file_name("#{dir}/#{basename}")
    survey_parsing.md5 = Digest::MD5.hexdigest(file_contents)

    if survey_parsing.changed? && survey_parsing.save
      Surveyor::Parser.parse_file(file)
      puts " ^---> Built"
    else
      puts " ^---> Skipped"
    end
  end

  def default_survey?
    stub = ParseStub.new
    stub.instance_eval(file_contents)
    stub.name == Survey::DEFAULT_ACCESS_CODE
  end

  # def error(job, exception)
  #   Airbrake.notify(exception)
  # end

  private

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