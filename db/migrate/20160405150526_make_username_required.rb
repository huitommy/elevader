class MakeUsernameRequired < ActiveRecord::Migration
  def up
    change_column :users, :username, :string, null: false
  end

  def down
    change_column :users, :username, :string, null: true
  end
end
