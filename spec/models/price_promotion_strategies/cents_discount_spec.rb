# frozen_string_literal: true

require "rails_helper"

RSpec.describe PricePromotionStrategies::CentsDiscount, type: :model do
  it { expect(described_class).to be < PricePromotionStrategy }

  describe "Validations" do
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe "#calculate_discount_money" do
    subject { instance.calculate_discount_money(quantity) }

    let(:instance) do
      described_class.new(
        amount: amount,
        quantity_to_buy: quantity_to_buy,
        quantity_to_discount: quantity_to_discount
      )
    end

    context "when discount applies for any quantity" do
      let(:quantity) { rand(100) }
      let(:amount) { 999 }
      let(:quantity_to_buy) { 1 }
      let(:quantity_to_discount) { nil }

      it { is_expected.to eq(Money.new(quantity * amount)) }
    end

    context "when discount applies for specific quantity" do
      let(:quantity) { 1 }
      let(:amount) { 999 }
      let(:quantity_to_buy) { 1 }
      let(:quantity_to_discount) { 2 }

      it { is_expected.to eq(Money.zero) }

      context "when quantity = 2" do
        let(:quantity) { 2 }

        it "applies only for one item" do
          is_expected.to eq(Money.new(amount))
        end
      end

      context "when quantity = 3" do
        let(:quantity) { 3 }

        it "applies for two item" do
          is_expected.to eq(Money.new(amount * 2))
        end
      end

      context "when quantity = 4" do
        let(:quantity) { 4 }

        it "applies for two item" do
          is_expected.to eq(Money.new(amount * 2))
        end
      end
    end
  end
end
