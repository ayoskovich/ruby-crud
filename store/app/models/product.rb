class Product < ApplicationRecord
  has_rich_text :description

  # Custom validator
  validates :name, presence: true
end
