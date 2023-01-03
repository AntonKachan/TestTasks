# frozen_string_literal: true

class Product < ApplicationRecord
  validates :code, :name, :price_cents, presence: true
  validates :code, uniqueness: true
end
