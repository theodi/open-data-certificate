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
    def merge(out_file, input_files)
      merged_output = input_files.reduce({}) do |memo, input_file|
        deep_merge!(memo, YAML.load_file(input_file))
        memo
      end

      locale = merged_output.keys.first
      merged_output = {locale => {'surveyor' => merged_output[locale]}}

      File.open(out_file, 'w:utf-8') { |f| f.write(YAML.dump(merged_output)) }
    end

    #TODO: replace with Hash#deep_merge on upgrade to activesupport >= 4
    def deep_merge!(hash, other_hash)
      other_hash.each_pair do |current_key, other_value|
        this_value = hash[current_key]
        hash[current_key] = if this_value.is_a?(Hash) && other_value.is_a?(Hash)
          deep_merge!(this_value, other_value)
        elsif this_value.is_a?(Array) && other_value.is_a?(Array)
          this_value + other_value
        else
          other_value
        end
      end
      return hash
    end

  end
end
