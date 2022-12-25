class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true
  validates :founded, numericality: { only_integer: true }
  validates :city, presence: true

  def member?(user)
    users.each do |u|
      return true if u.id == user.id
    end
    false
  end
end
