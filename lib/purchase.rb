require 'bigdecimal'

class Purchase
  attr_reader :product, :final_price

  def initialize(product)
    @product = product
    @final_price = product.price
  end

  def final_price=(value)
    @final_price = BigDecimal(value)
  end
end