class PopulateCuratorForCertificates < ActiveRecord::Migration
  def up
    Certificate.where(curator: nil).find_each(batch_size: 20) do |c| 
      c.delay.update_from_response_set unless c.response_set.nil?
    end
  end

  def down
  end
end
