require 'product'
require 'checkout'

describe Checkout do
  let(:service) { described_class.new(products, discounts) }
  let(:products) do
    [
        Product.new(name: 'Tomato', short_name: :TO, price: '1.5'),
        Product.new(name: 'Potato', short_name: :PO, price: '0.3')
    ]
  end
  let(:discounts) { [] }

  describe '#total' do
    let(:requested_products) { [:TO, :PO, :PO] }

    it 'calculates total price of all items' do
      requested_products.each { |p| service.add(p) }
      expect(service.total).to eq(BigDecimal('2.1'))
    end

    context 'with discounts' do
      class TwoPotatoAsOneDiscount
        def apply(purchases)
          purchases
              .select { |purchase| purchase.product.short_name == :PO }
              .each_slice(2)
              .each { |purchase| purchase[1]&.final_price = 0 }
        end
      end

      let(:discounts) { [TwoPotatoAsOneDiscount.new] }

      it 'applies discounts to purchases' do
        requested_products.each { |p| service.add(p) }
        expect(service.total).to eq(BigDecimal('1.8'))
      end

      it 'does not discount twice on subsequent totals' do
        service.add(:PO)
        2.times.each { expect(service.total).to eq(BigDecimal('0.3')) }
      end
    end
  end

  describe '#add' do
    it 'accepts anything convertable to symbol' do
      expect { service.add('TO') }.to change { service.items }
    end

    # Probably not needed
    # it 'ignores nil'
  end
end