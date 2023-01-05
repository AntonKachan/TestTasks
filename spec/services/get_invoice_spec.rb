# frozen_string_literal: true

require "rails_helper"

RSpec.describe GetInvoice, type: :service do
  subject(:service_call) { described_class.new(product_ids: product_ids).call }

  let(:expected_response) { { total_price: Money.new(expected_total_price) } }
  let(:expected_total_price) { 0 }

  context "when product_ids = nil" do
    let(:product_ids) { nil }
    let(:expected_total_price) { 0 }

    it { is_expected.to eq(expected_response) }
  end

  context "when product_ids don't exist" do
    let(:product_ids) { [1,2] }

    it "raises RecordNotFound" do
      expect { service_call }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "when product_ids exists" do
    let(:product1) { create(:product, price_cents: 1999) }
    let(:product2) { create(:product, price_cents: 2999) }
    let(:expected_total_price) { product1.price_cents + product2.price_cents }
    let(:product_ids) { [product1.id, product2.id] }

    it "calculates correct total_sum" do
      expect(service_call).to eq(expected_response)
    end
  end
end
