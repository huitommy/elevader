class DropTotalVotes < ActiveRecord::Migration
  def change
    remove_column :reviews, :total_votes, :integer, default: 0, null: false
  end
end
