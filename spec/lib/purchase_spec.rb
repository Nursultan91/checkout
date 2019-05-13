require 'purchase'
require 'product'

describe Purchase do
  let(:purchase) { described_class.new(product) }
  let(:product) { Product.new(name: 'Potato', short_name: 'PO', price: '99.99') }

  describe '#new' do
    it 'allows access to product' do
      expect(purchase.product).to be(product)
    end

    it 'sets final_price same as product price and allows access it' do
      expect(purchase.final_price).to eq(product.price)
    end
  end

  describe '#final_price=' do
    it 'always sets value to bigdecimal' do
      purchase.final_price = '1.85'
      expect(purchase.final_price).to eq(BigDecimal('1.85'))
    end
  end
end