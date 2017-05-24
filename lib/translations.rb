module Translations

  module Merge
    module_function
    def merge(out_file, input_files)
      merged_output = input_files.reduce({}) do |memo, input_file|
        yaml = if File.exist?(input_file)
          YAML.load_file(input_file) || {}
        else
          {}
        end

        deep_merge!(memo, yaml)
        memo
      end

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
