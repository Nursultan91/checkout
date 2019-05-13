$LOAD_PATH << File.join(File.dirname(__FILE__), "lib")
require 'pry-byebug'
require 'checkout'
require 'product'
require 'gift_for_target_discount'
require 'mass_group_discount'

products = [
    [:CC, 'Кока-Кола', '1.50'],
    [:PC, 'Пепси Кола', '2.00'],
    [:WA, 'Вода', '0.85'],
    [:JD, 'Jack Daniels', '30.00']
].map { |data| Product.new(name: data[1], short_name: data[0], price: data[2]) }

discounts = [
    GiftForTargetDiscount.new(:CC, :CC),
    GiftForTargetDiscount.new(:JD, :CC),
    MassGroupDiscount.new(
        target_short_name: :PC,
        amount_threshold: 3,
        discount: 20
    )
]

checkout = Checkout.new(products, discounts)
short_names = ARGV.join(' ').split(/\s+/)
short_names.each { |product_short_name| checkout.add(product_short_name) }

puts "Total: $#{checkout.total.to_f}"