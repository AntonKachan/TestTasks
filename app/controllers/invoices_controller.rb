# frozen_string_literal: true

class InvoicesController < ApplicationController
  def index
    @invoice = GetInvoice.new(product_ids: product_ids).call
  end

  private

  def product_ids
    @product_ids ||= params.fetch(:product_ids, []).map(&:to_i)
  end
end
