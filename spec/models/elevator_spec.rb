require 'rails_helper'

RSpec.describe Elevator do
  describe '#average_rating' do
    let(:elevator) { FactoryGirl.create(:elevator) }

    it 'returns rounded average of all ratings for the elevator' do
      expect(elevator.average_rating).to eq(0)
      
      [1, 1, 5].each { |rtg| FactoryGirl.create(:review, elevator: elevator, rating: rtg) }

      expect(elevator.average_rating).to eq(2)

      FactoryGirl.create(:review, elevator: elevator, rating: 4)

      expect(elevator.average_rating).to eq(3)
    end
  end
end
