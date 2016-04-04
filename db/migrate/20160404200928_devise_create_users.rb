class DeviseCreateUsers < ActiveRecord::Migration
  def up
    change_column :users, :email, :string, null: false, default: ""

    add_column :users, :encrypted_password, :string, null: false, default: ""
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    add_column :users, :remember_created_at, :datetime
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :inet
    add_column :users, :last_sign_in_ip, :inet

    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime

    add_index :users, :reset_password_token, unique: true
  end

  def down
    change_column :users, :email, :string, null: false

    remove_column :users, :encrypted_password
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at

    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip

    remove_column :users, :created_at
    remove_column :users, :updated_at
  end
end
