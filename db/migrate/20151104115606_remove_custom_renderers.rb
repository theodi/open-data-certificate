class RemoveCustomRenderers < ActiveRecord::Migration
  def up
    remove_column :answers, :custom_renderer
    remove_column :question_groups, :custom_renderer
    remove_column :questions, :custom_renderer
  end

  def down
    add_column :answers, :custom_renderer, :string
    add_column :question_groups, :custom_renderer, :string
    add_column :questions, :custom_renderer, :string
  end
end
