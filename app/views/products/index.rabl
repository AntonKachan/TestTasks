# frozen_string_literal: true

collection @products, root: false, object_root: false
attributes :id, :code, :name
node(:price) { |o| Money.new(o.price_cents).format }
