module Translations
  class SpreadsheetConverter
    def initialize(input_path)
      @workbook = RubyXL::Parser.parse(input_path)
    end

    def extract_translations(sheet_name)
      @workbook[sheet_name].extract_data.compact.map do |row|
        row.values_at(0, 2)
      end
    end

    def translations(sheet_name)
      extract_translations(sheet_name).reject do |row|
        row.compact.empty?
      end
    end

    def extract(sheet_name, output_path)
      File.open(output_path, 'w') do |f|
        translations(sheet_name).each do |key, t|
          f.puts([key, clean(t)].join(':'))
        end
      end
    end

    def clean(translation)
      translation.gsub(/[[:space:]]+/, ' ').strip
    end
  end
end
