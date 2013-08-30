class AddAutocompleteOverrideExplanationToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :autocomplete_override_explanation, :string
  end
end
