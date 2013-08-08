class PagesController < HighVoltage::PagesController
  
  def show
    respond_to do |format|
      format.html { super }
    end
  end
  
end