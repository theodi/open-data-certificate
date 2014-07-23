class QuestionGroup < ActiveRecord::Base
  include Surveyor::Models::QuestionGroupMethods

   def translation(locale)
     {:text => self.text, :help_text => self.help_text}.with_indifferent_access
   end

end
