module OdiI18nBackend
  def store_translations(locale, data, options={})
    super(locale, data, options)
    super('db', deep_duplicate_locale_strings(data), options) if locale == 'en'
  end

  def deep_duplicate_locale_strings(data)
    data.inject({}) do |result, (k,v)|
      unless v.blank?
        result[k] = if v.is_a?(Hash)
          deep_duplicate_locale_strings(v)
        elsif v.is_a?(String)
          "#{v} #{v}"
        else
          v
        end
      end
      result
    end
  end
end

unless Rails.env.production?
  I18n::Backend::Simple.include(OdiI18nBackend)
end
