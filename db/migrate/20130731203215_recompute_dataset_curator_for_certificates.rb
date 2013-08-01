class RecomputeDatasetCuratorForCertificates < ActiveRecord::Migration
  def up
    # REMOVED - https://theodi.airbrake.io/groups/64547582

    # puts "...this may take some time\n"
    # this may still result in curator:nil for some certificates (where it's not supplied, or
    # there isn't a matching question on the survey)
    # Certificate.where(curator: nil).find_each(batch_size: 20) do |c| 
    #   c.update_from_response_set unless c.response_set.nil?
    # end
  end

  def down
  end
end
