class CreateTimestamp < ActiveRecord::Migration
  def up
    add_timestamps(:elevators)
  end

  def down
    remove_timestamps(:elevators)
  end
end
