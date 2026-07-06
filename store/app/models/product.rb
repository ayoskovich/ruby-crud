class Product < ApplicationRecord
  has_one_attached :featured_image
  has_rich_text :description

  # Custom validator
  validates :name, presence: true
end
