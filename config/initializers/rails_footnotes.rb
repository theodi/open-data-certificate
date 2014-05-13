if defined?(Footnotes) && Rails.env.development? && (!ENV["DISABLE_FOOTNOTES"] || ENV["DISABLE_FOOTNOTES"] != "true")
  Footnotes.run!
  Footnotes::Filter.no_style = true
end
