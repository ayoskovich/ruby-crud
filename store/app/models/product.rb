class Product < ApplicationRecord
  # Custom validator
  validates :name, presence: true
end
