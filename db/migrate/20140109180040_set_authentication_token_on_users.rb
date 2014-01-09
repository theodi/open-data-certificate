class SetAuthenticationTokenOnUsers < ActiveRecord::Migration
  def up
    User.all.each{|u| u.save}
  end

  def down
  end
end
