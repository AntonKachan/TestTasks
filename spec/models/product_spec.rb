# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price_cents) }
    it { is_expected.to_not validate_presence_of(:price_promotion_strategy_id) }

    it { is_expected.to validate_uniqueness_of(:code) }
  end

  describe "Associations" do
    it { is_expected.to belong_to(:price_promotion_strategy).optional }
  end

  describe "#discount_for" do
    subject { product.discount_for(quantity: quantity) }

    let(:product) { build(:product) }
    let(:quantity) { 2 }

    context "without price_promotion_strategy" do
      it { is_expected.to eq(Money.zero) }
    end

    context "with strategy: buy 1 - get 1 free" do
      let(:price_promotion_strategy) do
        build(:percent_promotion_strategy,
              amount: 100,
              quantity_to_buy: 1,
              quantity_to_discount: 1)
      end
      let(:product) { build(:product, price_promotion_strategy: price_promotion_strategy) }

      context "when buy 1 item" do
        let(:quantity) { 1 }

        it { is_expected.to eq(Money.zero) }
      end

      context "when buy 2 items" do
        let(:quantity) { 2 }

        it { is_expected.to eq(Money.new(product.price_cents)) }
      end

      context "when buy 3 items" do
        let(:quantity) { 3 }

        it { is_expected.to eq(Money.new(product.price_cents)) }
      end

      context "when buy 4 items" do
        let(:quantity) { 4 }

        it { is_expected.to eq(Money.new(product.price_cents * 2)) }
      end
    end

    context "with strategy: buy 3 - get 50 cents off" do
      let(:cents_discount) { 50 }
      let(:price_promotion_strategy) do
        build(:cents_promotion_strategy,
              amount: cents_discount,
              quantity_to_buy: 3,
              quantity_to_discount: nil)
      end
      let(:product) { build(:product, price_promotion_strategy: price_promotion_strategy) }

      context "when buy 2 items" do
        let(:quantity) { 2 }

        it { is_expected.to eq(Money.zero) }
      end

      context "when buy 3 items" do
        let(:quantity) { 3 }

        it { is_expected.to eq(Money.new(cents_discount * quantity)) }
      end

      context "when buy 4 items" do
        let(:quantity) { 4 }

        it { is_expected.to eq(Money.new(cents_discount * quantity)) }
      end
    end

    context "with strategy: buy 3 - the base price drops to 2/3" do
      let(:price_promotion_strategy) do
        build(:percent_promotion_strategy,
              amount: (discount * 100).round(4),
              quantity_to_buy: 3,
              quantity_to_discount: nil)
      end
      let(:discount) { 1/3.0 }
      let(:base_price) { 1123 }
      let(:product) { build(:product, price_cents: base_price, price_promotion_strategy: price_promotion_strategy) }

      context "when buy 2 items" do
        let(:quantity) { 2 }

        it { is_expected.to eq(Money.zero) }
      end

      context "when buy 3 items" do
        let(:quantity) { 3 }

        it { is_expected.to eq(Money.new(base_price)) }
      end

      context "when buy 4 items" do
        let(:quantity) { 4 }

        it { is_expected.to eq(Money.new(discount * base_price * 4)) }
      end
    end
  end
end
