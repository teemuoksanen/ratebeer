class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user, counter_cache: true

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  scope :recent, -> { Rating.last(5).reverse }

  def self.top(n)
    top = {}
    top_n_raters = Rating.group('user_id').count('score').take(n)
    top_n_raters.each do |k, v| top.store(User.find_by(id: k), v) end
    top
  end

  def to_s
    "#{beer.name} #{score}"
  end
end
