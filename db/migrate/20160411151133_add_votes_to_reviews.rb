class AddVotesToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :total_votes, :integer, null: false, default: 0
  end
end
