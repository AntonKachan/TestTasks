class AddPricePromotionStrategyToProduct < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :price_promotion_strategy, foreign_key: true
  end
end
