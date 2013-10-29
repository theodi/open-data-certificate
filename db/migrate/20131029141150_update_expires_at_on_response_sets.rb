class UpdateExpiresAtOnResponseSets < ActiveRecord::Migration
  def up
    Survey.all.map(&:schedule_expiries)
  end

  def down
  end
end
