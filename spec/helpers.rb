module Helpers
  def check_review_order(earlier_review, later_review)
    earlier_content = 'id="review-' + earlier_review.id.to_s + '"'
    later_content = 'id="review-' + later_review.id.to_s + '"'
    expect(earlier_content).to appear_before(later_content)
  end
end