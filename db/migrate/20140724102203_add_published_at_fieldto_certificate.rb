class AddPublishedAtFieldtoCertificate < ActiveRecord::Migration
  def up
    add_column :certificates, :published_at, :datetime
    add_column :certificates, :aasm_state, :string

    Certificate.where(published: true).each { |c| c.update_attributes(aasm_state: :published, published_at: c.created_at) }
    Certificate.where(published: false).each { |c| c.update_attributes(aasm_state: :draft) }
  end

  def down
    remove_column :certificates, :published_at
  end
end
