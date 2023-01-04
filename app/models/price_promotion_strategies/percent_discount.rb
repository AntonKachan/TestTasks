# frozen_string_literal: true

module PricePromotionStrategies
  class PercentDiscount < ::PricePromotionStrategy
    validates :amount,
              numericality: {
                greater_than_or_equal_to: 1,
                less_than_or_equal_to: 100,
              }

    def calculate_discount_money(quantity, base_price)
      Money.new(number_of_discountable_from(quantity: quantity) * amount * base_price / 100)
    end
  end
end
