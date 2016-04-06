class AddUserIdToElevators < ActiveRecord::Migration
  def change
    add_column :elevators, :user_id, :integer, null: false
  end
end
