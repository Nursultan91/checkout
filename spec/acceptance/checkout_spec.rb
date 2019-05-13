require 'checkout'
require 'product'
require 'gift_for_target_discount'
require 'mass_group_discount'

describe 'Checkout acceptance' do
  let(:service) { Checkout.new(products, discounts) }
  let(:cola_product) { Product.new(name: 'Кока-Кола', short_name: :CC, price: '1.50') }
  let(:pepsi_product) { Product.new(name: 'Пепси Кола', short_name: :PC, price: '2.00') }
  let(:water_product) { Product.new(name: 'Вода', short_name: :WA, price: '0.85') }
  let(:jack_product) { Product.new(name: 'Jack Daniels', short_name: :JD, price: '30.00') }
  let(:products) do
    [
        cola_product,
        pepsi_product,
        water_product,
        jack_product
    ]
  end
  let(:discounts) { [] }

  it 'calculates total as sum of purchases final_price when no discount applied' do
    %i[WA WA PC].each do |requested_product|
      service.add(requested_product)
    end

    expect(service.total).to eq(3.7)
  end

  context 'when coca-cola is bought' do
    let(:discounts) do
      [
          GiftForTargetDiscount.new(cola_product.short_name, cola_product.short_name)
      ]
    end

    it 'gifts second one' do
      %i[CC CC].each do |requested_product|
        service.add(requested_product)
      end

      expect(service.total).to eq(cola_product.price)
    end
  end

  context 'when jack daniels is bought' do
    let(:discounts) do
      [
          GiftForTargetDiscount.new(jack_product.short_name, cola_product.short_name)
      ]
    end

    it 'gifts coca-cola' do
      %i[JD CC].each do |requested_product|
        service.add(requested_product)
      end

      expect(service.total).to eq(jack_product.price)
    end
  end

  context 'when pepsi-cola is bought' do
    let(:discounts) do
      [
          MassGroupDiscount.new(
              target_short_name: pepsi_product.short_name,
              amount_threshold: 3,
              discount: 20
          )
      ]
    end

    it 'discounts each pepsi-cola for 20% after two bottles' do
      %i[PC PC PC].each do |requested_product|
        service.add(requested_product)
      end

      expect(service.total).to eq(4.8)
    end
  end

  # Probably redudant
  context 'when input is set' do
    let(:discounts) do
      [
          GiftForTargetDiscount.new(cola_product.short_name, cola_product.short_name),
          GiftForTargetDiscount.new(jack_product.short_name, cola_product.short_name),
          MassGroupDiscount.new(
              target_short_name: pepsi_product.short_name,
              amount_threshold: 3,
              discount: 20
          )
      ]
    end

    def service_call_with(input)
      input.split(/\s/).each { |product_short_name| service.add(product_short_name) }
      service.total
    end

    specify { expect(service_call_with('CC PC WA')).to eq(4.35) }
    specify { expect(service_call_with('CC PC CC CC')).to eq(5.00) }
    specify { expect(service_call_with('PC CC PC WA PC CC')).to eq(7.15) }
  end
end