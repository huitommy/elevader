class AddUserToElevators < ActiveRecord::Migration
  def change
    add_column :elevators, :user_id, :integer, references: :users, null: false
  end
end
