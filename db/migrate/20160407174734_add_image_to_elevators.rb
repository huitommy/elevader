class AddImageToElevators < ActiveRecord::Migration
  def change
    add_column :elevators, :elevator, :string
  end
end
