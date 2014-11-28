class CorrectHandlingOfNames < ActiveRecord::Migration
  def up
    add_column :users, :name, :string, :null => true, :after => :email
    add_column :users, :short_name, :string, :null => true, :after => :name
    update(<<-SQL)
      update users set short_name = first_name,
        name = trim(concat(coalesce(first_name, ''), ' ', coalesce(last_name, '')))
    SQL
    remove_column :users, :first_name
    remove_column :users, :last_name
  end

  def down
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    update(<<-SQL)
      update users set first_name = short_name,
        last_name = trim(replace(short_name, name, ''))
    SQL
    remove_column :users, :name
    remove_column :users, :short_name
  end
end
