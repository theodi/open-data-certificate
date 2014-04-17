class ChangeOglukLicenceId < ActiveRecord::Migration
  def up
    data = Answer.joins(:question).where(questions: {:reference_identifier => 'dataLicence'}).readonly(false)
    
    data.each do |d|
      case d.reference_identifier
      when "uk_ogl"
        d.update_attributes(:reference_identifier => "ogl_uk")
      end
    end
    
    content = Answer.joins(:question).where(questions: {:reference_identifier => 'contentLicence'}).readonly(false)
    
    content.each do |c|    
      case c.reference_identifier
      when "uk_ogl"
        c.update_attributes(:reference_identifier => "ogl_uk")
      end
    end
  end

  def down
  end
end
