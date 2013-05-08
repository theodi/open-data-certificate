class AddPlaceholderTypeAndMoreLinkAttributes < ActiveRecord::Migration
  def change
    add_column :questions, :help_text_more_url, :string
    add_column :answers, :help_text_more_url, :string
    add_column :answers, :input_type, :string
    add_column :answers, :placeholder, :string
  end
end
