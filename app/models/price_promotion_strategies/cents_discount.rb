# frozen_string_literal: true

module PricePromotionStrategies
  class CentsDiscount < ::PricePromotionStrategy
    validates :amount, numericality: { greater_than: 0 }

    def calculate_discount_money(quantity, *)
      Money.new(number_of_discountable_from(quantity: quantity) * amount)
    end
  end
end
