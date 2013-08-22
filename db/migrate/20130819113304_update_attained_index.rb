class UpdateAttainedIndex < ActiveRecord::Migration
  def up
    ResponseSet.where(aasm_state: [:archived, :published]).each do |response_set| 
      response_set.delay.store_attained_index
    end
  end

  def down
  end
end
