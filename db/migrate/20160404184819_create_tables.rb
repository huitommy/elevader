class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email, null: false
    end

    add_index :users, :email, unique: true

    create_table :elevators do |t|
      t.string :building_name, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :zipcode, null: false
      t.string :state, null: false
    end

    add_index :elevators, :building_name, unique: true

    create_table :reviews do |t|
      t.belongs_to :user, null: false
      t.belongs_to :elevator, null: false
      t.integer :rating, null: false
      t.text :body
    end
  end
end
