class ChangeLicenceIdentifiers < ActiveRecord::Migration
  def up
    data = Answer.joins(:question).where(questions: {:reference_identifier => 'dataLicence'}).readonly(false)
    
    data.each do |d|
      case d.reference_identifier
      when "odc_by_sa"
        d.update_attributes(:reference_identifier => "odc_odbl")
      when "pddl"
        d.update_attributes(:reference_identifier => "odc_pddl")
      when "cc0"
        d.update_attributes(:reference_identifier => "cc_zero")
      when "ogl"
        d.update_attributes(:reference_identifier => "uk_ogl")
      end
    end
    
    content = Answer.joins(:question).where(questions: {:reference_identifier => 'contentLicence'}).readonly(false)
    
    content.each do |c|    
      case c.reference_identifier
      when "cc0"
        c.update_attributes(:reference_identifier => "cc_zero")
      when "ogl"
        c.update_attributes(:reference_identifier => "uk_ogl")
      end
    end
  end

  def down
  end
end
