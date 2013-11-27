class AddDiscussionTopicToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :discussion_topic, :string
  end
end
