if defined?(Footnotes) && Rails.env.development? && (ENV["ENABLE_FOOTNOTES"] == "true")
  Footnotes.run!
  Footnotes::Filter.no_style = true
end
