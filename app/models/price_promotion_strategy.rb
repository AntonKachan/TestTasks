# frozen_string_literal: true

class PricePromotionStrategy < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :amount, :quantity_to_buy, presence: true

  def calculate_discount_money(*)
    raise NotImplementedError, "#calculate_discount_money must be defined in a subclass."
  end

  protected

  def number_of_discountable_from(quantity:)
    return 0 if quantity < quantity_to_buy
    return quantity if quantity_to_discount.nil?

    bundle_size = quantity_to_buy + quantity_to_discount
    number_of_bundles = quantity / bundle_size

    return quantity - quantity_to_buy if number_of_bundles.zero?

    number_of_bundles * quantity_to_discount + [quantity % bundle_size - quantity_to_buy, 0].max
  end
end
