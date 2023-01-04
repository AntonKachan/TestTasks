# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :price_promotion_strategy, optional: true

  validates :code, :name, :price_cents, presence: true
  validates :code, uniqueness: true

  def discount_for(quantity:)
    return Money.zero if price_promotion_strategy.nil?

    price_promotion_strategy.calculate_discount_money(quantity, price_cents)
  end
end
