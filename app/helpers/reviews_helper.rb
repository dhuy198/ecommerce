module ReviewsHelper
  def star_rating(rating, size = "text-lg")
    content_tag :div, class: "flex items-center" do
      rating.times do
        concat content_tag(:span, "★", class: "#{size} text-yellow-400")
      end
      (5 - rating).times do
        concat content_tag(:span, "☆", class: "#{size} text-gray-300")
      end
    end
  end

  def average_rating(reviews)
    return 0 if reviews.empty?
    reviews.average(:star).to_f.round(1)
  end

  def rating_percentage(reviews, rating)
    return 0 if reviews.empty?
    (reviews.where(star: rating).count.to_f / reviews.count * 100).round(1)
  end

  def review_count_text(reviews)
    count = reviews.count
    case count
    when 0
      "No reviews yet"
    when 1
      "1 review"
    else
      "#{count} reviews"
    end
  end

  def can_review_product?(product, user)
    user_signed_in? && !product.reviews.exists?(user: user)
  end

  def can_edit_review?(review, user)
    user_signed_in? && review.user == user
  end
end
