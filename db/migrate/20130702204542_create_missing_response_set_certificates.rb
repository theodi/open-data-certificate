class CreateMissingResponseSetCertificates < ActiveRecord::Migration
  def up
    rsets = ResponseSet.includes(:certificate).all.select {|rs| rs.certificate.nil?}

    rsets.each {|r| r.update_certificate}
  end

  def down
  end
end
