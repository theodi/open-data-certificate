class AddPublishedAtFieldtoCertificate < ActiveRecord::Migration
  def up
    add_column :certificates, :published_at, :datetime
    Certificate.where(published: true).each { |c| c.update_attributes(published_at: c.created_at) }
  end

  def down
    remove_column :certificates, :published_at
  end
end
