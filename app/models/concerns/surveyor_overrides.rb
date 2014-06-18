module SurveyorOverrides
  extend ActiveSupport::Concern

  def translation(locale_symbol)
    {:title => self.title, :description => self.description}.with_indifferent_access.merge(trns(locale_symbol))
  end

  # prevent the translations from being loaded all the time
  def trns(locale_symbol)
    return @trns unless @trns.nil?
    t = self.translations.where(:locale => locale_symbol.to_s).first
    @trns = t ? YAML.load(t.translation || "{}").with_indifferent_access : {}
  end

  def question(identifier)
    questions.select{|q| q.reference_identifier == identifier.to_s }.first
  end

  def documentation_url
    question 'documentationUrl'
  end

end
