module DetermineFromResponses
  extend ActiveSupport::Concern

  def data_licence_determined_from_responses
    if @data_licence_determined_from_responses.nil?
      ref = value_for :data_licence, :reference_identifier
      case ref
      when nil
        @data_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "na"
        @data_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "other"
         @data_licence_determined_from_responses = {
          :title => value_for(:other_dataset_licence_name),
          :url   => value_for(:other_dataset_licence_url)
         }
      else
        licence = Odlifier::License.new(ref.dasherize)
        @data_licence_determined_from_responses = {
          :title => licence.title,
          :url   => licence.url
        }
      end
    end
    @data_licence_determined_from_responses
  end

  def content_licence_determined_from_responses
    if @content_licence_determined_from_responses.nil?
      ref = value_for :content_licence, :reference_identifier
      case ref
      when nil
        @content_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "na"
        @content_licence_determined_from_responses = {
          :title => "Not Applicable",
          :url => nil
        }
      when "other"
         @content_licence_determined_from_responses = {
          :title => value_for(:other_content_licence_name),
          :url   => value_for(:other_content_licence_url)
         }
      else
        begin
          licence = Odlifier::License.new(ref.dasherize)
          @content_licence_determined_from_responses = {
            :title => licence.title,
            :url   => licence.url
          }
        rescue ArgumentError
          @content_licence_determined_from_responses = {
            :title => 'Unknown',
            :url   => nil
          }
        end
      end
    else
      @content_licence_determined_from_responses
    end
  end

  def method_missing(method_name, *args, &blk)
    val = method_name.to_s.match(/(.+)_determined_from_responses/)
    unless val.nil? or survey.map[val[1].to_sym].nil?
      var = instance_variable_get("@#{method_name}")
      var ||= value_for val[1].to_sym
    else
      super
    end
  end

end
