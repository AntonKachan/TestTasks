# frozen_string_literal: true

FactoryBot.define do
  factory :price_promotion_strategy do
    amount { 1.5 }
    quantity_to_buy { 1 }
    quantity_to_discount { nil }
  end

  factory :cents_promotion_strategy,
          class: PricePromotionStrategies::CentsDiscount,
          parent: :price_promotion_strategy do
  end

  factory :percent_promotion_strategy,
          class: PricePromotionStrategies::PercentDiscount,
          parent: :price_promotion_strategy do
  end
end
