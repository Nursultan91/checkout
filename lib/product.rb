require 'bigdecimal'

class Product
  attr_reader :name, :short_name, :price

  def initialize(name:, short_name:, price:)
    @name = name.to_s
    @short_name = short_name.to_sym
    @price = BigDecimal(price)
  end
end