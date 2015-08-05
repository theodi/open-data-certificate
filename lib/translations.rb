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
      translation.to_s.gsub(/[[:space:]]+/, ' ').strip
    end
  end

  module Merge
    module_function
    def merge(a, b, out)
      input_a, input_b = YAML.load_file(a), YAML.load_file(b)
      deep_merge!(input_a, input_b)
      File.open(out, 'w:utf-8') { |f| f.write(YAML.dump(input_a)) }
    end

    #TODO: replace with Hash#deep_merge on upgrade to activesupport >= 4
    def deep_merge!(hash, other_hash)
      other_hash.each_pair do |current_key, other_value|
        this_value = hash[current_key]
        hash[current_key] = if this_value.is_a?(Hash) && other_value.is_a?(Hash)
          deep_merge!(this_value, other_value)
        elsif hash.key?(current_key)
          this_value + other_value
        else
          other_value
        end
      end
      return hash
    end

  end
end
