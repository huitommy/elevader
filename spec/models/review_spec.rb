require 'rails_helper'

RSpec.describe Review do
  describe '#count_votes' do
    let(:review) { FactoryGirl.create(:review) }

    it 'returns total number of votes for specific review' do
      FactoryGirl.create(:vote, review: review, vote: 1)
      FactoryGirl.create(:vote, review: review, vote: -1)
      FactoryGirl.create(:vote, review: review, vote: -1)

      expect(review.count_votes).to eq(-1)

      FactoryGirl.create(:vote, review: review, vote: 1)
      FactoryGirl.create(:vote, review: review, vote: 1)
      FactoryGirl.create(:vote, review: review, vote: 1)

      expect(review.count_votes).to eq(2)

      FactoryGirl.create(:vote, review: review, vote: -1)
      FactoryGirl.create(:vote, review: review, vote: -1)

      expect(review.count_votes).to eq(0)
    end

    it 'returns zero if no votes have been added to review' do
      expect(review.count_votes).to eq(0)
    end

    it 'updates the number of votes in total_votes instance var' do
      FactoryGirl.create(:vote, review: review, vote: 1)
      review.count_votes
      expect(review.total_votes).to eq(1)

      FactoryGirl.create(:vote, review: review, vote: 1)
      review.count_votes
      expect(review.total_votes).to eq(2)

      FactoryGirl.create(:vote, review: review, vote: -1)
      review.count_votes
      expect(review.total_votes).to eq(1)
    end
  end
end
