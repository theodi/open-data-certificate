class DependencyCondition < ActiveRecord::Base
  unloadable
  include Surveyor::Models::DependencyConditionMethods


  # overriding the to_hash method to add support for:
  # 
  #    condition_X :q_name, '==', {:string_value => '', :answer_reference => '1'}
  #
  # in the original implementation this doesn't work because a
  # blank response is nil, rather than ""
  def to_hash(response_set, responses_pre = nil)

    responses_pre = response_set.responses.all unless responses_pre

    if ['==', '!='].include?(operator) && string_value == ""
      is_blank = true

      responses_pre.select {|rs| rs[:answer_id] == answer_id} .each do |response|
      # response_set.responses.where(answer_id: answer).each do |response|
        is_blank = false unless response.data_value.blank?
      end

      flip = operator == '!='
      
      {rule_key.to_sym => flip ^ is_blank}
    else

      # We've brought the response set in here
      # super response_set

      responses = question.blank? ? [] : responses_pre.select {|x| question.answer_ids.include? x.answer_id} 
      #response_set.responses.where("responses.answer_id in (?)", question.answer_ids).all
      if self.operator.match /^count(>|>=|<|<=|==|!=)\d+$/
        op, i = self.operator.scan(/^count(>|>=|<|<=|==|!=)(\d+)$/).flatten
        # logger.warn({rule_key.to_sym => responses.count.send(op, i.to_i)})
        return {rule_key.to_sym => (op == "!=" ? !responses.count.send("==", i.to_i) : responses.count.send(op, i.to_i))}
      elsif operator == "!=" and (responses.blank? or responses.none?{|r| r.answer_id == self.answer_id})
        # logger.warn( {rule_key.to_sym => true})
        return {rule_key.to_sym => true}
      elsif response = responses.detect{|r| r.answer_id == self.answer_id}
        klass = response.answer.response_class
        klass = "answer" if self.as(klass).nil? # it should compare answer ids when the dependency condition *_value is nil
        case self.operator
        when "==", "<", ">", "<=", ">="
          # logger.warn( {rule_key.to_sym => response.as(klass).send(self.operator, self.as(klass))})
          return {rule_key.to_sym => !response.as(klass).nil? && response.as(klass).send(self.operator, self.as(klass))}
        when "!="
          # logger.warn( {rule_key.to_sym => !response.as(klass).send("==", self.as(klass))})
          return {rule_key.to_sym => !response.as(klass).send("==", self.as(klass))}
        end
      end
      # logger.warn({rule_key.to_sym => false})
      {rule_key.to_sym => false}



    end
  end
end
