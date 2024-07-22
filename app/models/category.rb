class Category < ApplicationRecord
has_one_attached :image do |attachable|
  attachable.variant :thumb,resize_to_limit:[100,100]
  # attachable.variant :medium, resize_to_limit:[250,250]
end
has_many :products , dependent: :destroy

validates :name, presence: true,uniqueness: true
validates :description, presence: true
end
