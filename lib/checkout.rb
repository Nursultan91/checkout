require 'purchase'

class Checkout
  attr_reader :items, :products, :discounts

  def initialize(products, discounts)
    # Raise error if multiple products have same short name?
    @products = products
    @discounts = discounts
    @items = []
  end

  def add(short_item_name)
    # Test nil?
    short_item_name = short_item_name.to_sym
    # Raise error if unexistent product added?
    product = products.find { |p| p.short_name == short_item_name }
    return if product.nil?
    @items << product
  end

  def total
    purchases = items.map { |product| Purchase.new(product) }
    discounts.each { |discount| discount.apply(purchases) }
    purchases.map(&:final_price).sum
  end
end