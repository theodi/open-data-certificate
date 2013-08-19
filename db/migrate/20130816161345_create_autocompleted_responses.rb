class CreateAutocompletedResponses < ActiveRecord::Migration
  def change
    create_table :autocompleted_responses do |t|

      t.timestamps
    end
  end
end
