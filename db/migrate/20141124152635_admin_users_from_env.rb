class AdminUsersFromEnv < ActiveRecord::Migration
  def up
    admin_ids = ENV.fetch("ODC_ADMIN_IDS", "").split(',')
    if admin_ids.any?
      execute("update users set admin = 1 where id in (#{admin_ids.join(',')})")
    end
  end

  def down
  end
end
