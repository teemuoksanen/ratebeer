class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true
  validates :founded, numericality: { only_integer: true }
  validates :city, presence: true
end
