class OdiLocale

  def self.changed_locale_path(current_path, new_locale)
    current_path.gsub(%r{\A/[a-z]{2}/(.*)}, "/#{new_locale}/\\1")
  end

end
