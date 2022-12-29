class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, presence: true

  def average
    return 0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  def self.top(top_n)
    top = {}
    averages_sorted_n = Rating.all.group('ratings.beer_id').average('ratings.score').sort_by{ |_, v| v }.reverse.take(top_n)
    averages_sorted_n.each do |k, v| top.store(Beer.find_by(id: k), v) end
    top
  end

  def to_s
    "#{name} (#{brewery.name})"
  end
end
