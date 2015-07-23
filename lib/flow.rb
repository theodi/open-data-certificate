class Flow

  def initialize(jurisdiction, type)
    path = get_path(jurisdiction, type)
    @xml = Nokogiri::XML(File.open(path))
    @xml_copy = Nokogiri::XML(File.open(path))
  end

  def get_path(jurisdiction, type)
    jurisdiction = "en" if (jurisdiction == "gb" && type == "Practical")
    jurisdiction.upcase! if type == "Legal"
    folder = folder_name(type)
    path = File.join(Rails.root, 'prototype', folder, "certificate.#{jurisdiction}.xml")
    unless File.exist?(path)
      path = File.join(Rails.root, 'prototype', folder, "certificate.en.xml")
    end
    path
  end

  def folder_name(type)
    {
      "Legal" => "jurisdictions",
      "Practical" => "translations"
    }[type]
  end

  def questions
    @xml_copy.xpath("//if").remove # remove any dependencies
    @xml_copy.xpath("//question").map do |q|
      question(q)
    end
  end

  def dependencies
    @xml.xpath("//if//question").map do |q|
      question(q, true)
    end
  end

  def question(q, dependency = true)
    {
      id: q["id"],
      label: label(q),
      type: type(q),
      level: level(q),
      answers: answers(q),
      prerequisites: dependency === true ? prerequisites(q) : nil
    }
  end

  def answers(question)
    if type(question) == "yesno"
      {
        "true" => {
          dependency: dependency(question, "true")
        },
        "false" => {
          dependency: dependency(question, "false")
        }
      }
    elsif question.at_xpath("radioset|checkboxset")
      answers = {}
      question.at_xpath("radioset|checkboxset").xpath("option").each do |option|
        answers[option.at_xpath("label").text] = {
          dependency: dependency(question, option["value"])
        }
      end
      answers
    elsif question.at_xpath("select")
      answers = {}
      question.at_xpath("select").xpath("option").each do |option|
        next if option["value"].nil?
        answers[option.text] = {
          dependency: dependency(question, option["value"])
        }
      end
      answers
    end
  end

  def label(question)
    CGI.unescapeHTML(question.at_xpath("label").text).gsub("\"", "'")
  end

  def type(question)
    if question.at_xpath("input")
      "input"
    elsif question.at_xpath("yesno")
      "yesno"
    elsif question.at_xpath("radioset")
      "radioset"
    elsif question.at_xpath("checkboxset")
      "checkboxset"
    end
  end

  def level(question)
    question.at_xpath("requirement")["level"] unless question.at_xpath("requirement").nil?
  end

  def dependency(question, answer)
    dependency = @xml.xpath("//if[contains(@test, \"this.#{question["id"]}() === '#{answer}'\")]").at_css("question")
    dependency["id"] unless dependency.nil?
  end

  def prerequisites(question)
    test = question.parent["test"] || question.parent.parent["test"]
    test.scan(/this\.([a-z]+)\(\)/i).map { |s| s[0] } unless test.nil?
  end

end
