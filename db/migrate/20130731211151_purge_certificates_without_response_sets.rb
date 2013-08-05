class PurgeCertificatesWithoutResponseSets < ActiveRecord::Migration
  def up
    Certificate.includes(:response_set).find_each {|c| c.destroy if c.response_set.nil?}
  end

  def down
  end
end
