if defined?(Footnotes) && Rails.env.development?
  Footnotes.run!

  Footnotes::Filter.no_style = true
end
