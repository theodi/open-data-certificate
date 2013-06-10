class DependencyCondition < ActiveRecord::Base
  unloadable
  include Surveyor::Models::DependencyConditionMethods


  # overriding the to_hash method to add support for:
  # 
  #    condition_X :q_name, '==', {:string_value => '', :answer_reference => '1'}
  #
  # in the original implementation this doesn't work because a
  # blank response is nil, rather than ""
  def to_hash(response_set)

    if ['==', '!='].include?(operator) && string_value == ""
      is_blank = true

      response_set.responses.where(answer_id: answer).each do |response|
        is_blank = false unless response.string_value.blank?
      end

      flip = operator == '!='
      
      {rule_key.to_sym => flip ^ is_blank}
    else
      super response_set
    end
  end
end
