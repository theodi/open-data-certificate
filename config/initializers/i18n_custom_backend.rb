module OdiI18nBackend
  def store_translations(locale, data, options={})
    super(locale, data, options)
    super('db', duplicate_locale_strings(data), options) if locale == 'en'
    super('bl', underscore_locale_strings(data), options) if locale == 'en'
  end

  def duplicate_locale_strings(data)
    deep_transform_locale_strings(data) do |locale_string|
      "#{locale_string} #{locale_string}"
    end
  end

  def underscore_locale_strings(data)
    deep_transform_locale_strings(data) do |locale_string|
      locale_string.gsub(/[^\s]/, '_')
    end
  end

  def deep_transform_locale_strings(data, &block)
    data.inject({}) do |result, (k,v)|
      unless v.blank?
        result[k] = if v.is_a?(Hash)
          deep_transform_locale_strings(v, &block)
        elsif v.is_a?(String)
          block.call(v)
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
