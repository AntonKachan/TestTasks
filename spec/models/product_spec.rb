# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "Validations" do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price_cents) }

    it { is_expected.to validate_uniqueness_of(:code) }
  end
end
