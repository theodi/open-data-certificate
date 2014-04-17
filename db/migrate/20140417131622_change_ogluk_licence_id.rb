class ChangeOglukLicenceId < ActiveRecord::Migration
  def up
    data = Answer.joins(:question).where(questions: {:reference_identifier => 'dataLicence'}).readonly(false)
    
    data.each do |d|
      case d.reference_identifier
      when "ogl_uk"
        d.update_attributes(:reference_identifier => "uk_ogl")
      end
    end
    
    content = Answer.joins(:question).where(questions: {:reference_identifier => 'contentLicence'}).readonly(false)
    
    content.each do |c|    
      case c.reference_identifier
      when "ogl_uk"
        c.update_attributes(:reference_identifier => "uk_ogl")
      end
    end
  end

  def down
  end
end
