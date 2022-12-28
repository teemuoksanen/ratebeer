class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 },
                       format: { with: /(?:[A-Z].*[0-9])|(?:[0-9].*[A-Z])/ }

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    style_ratings = ratings.joins(:beer).group('beers.style_id').average('ratings.score')
    favorite_style = Style.where(id: style_ratings.key(style_ratings.values.max)).first
    favorite_style.name
  end

  def favorite_brewery
    return nil if ratings.empty?

    brewery_ratings = ratings.joins(beer: :brewery).group('breweries.name').average('ratings.score')
    brewery_ratings.key(brewery_ratings.values.max)
  end

  def to_s
    username
  end
end
