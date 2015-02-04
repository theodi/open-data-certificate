class ConfirmExistingUsers < ActiveRecord::Migration
  def up
    update("update users set confirmed_at = now() where sign_in_count > 0")
  end

  def down
  end
end
