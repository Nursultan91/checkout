require 'gift_for_target_discount'
require 'product'
require 'purchase'

describe GiftForTargetDiscount do
  describe '#apply' do
    let(:discount) { described_class.new(target_product.short_name, gift_product.short_name) }
    let(:gift_product) { Product.new(name: 'Orange', short_name: 'ORR', price: '0.94') }
    let(:target_product) { Product.new(name: 'Potato', short_name: 'PO', price: '1.5') }
    let(:non_target_product) { Product.new(name: 'Tomato', short_name: 'TO', price: '0.3') }
    let(:purchases) do
      [
          Purchase.new(gift_product),
          Purchase.new(target_product),
          Purchase.new(non_target_product),
      ]
    end

    it 'nullifies price of gifted item' do
      discount.apply(purchases)
      expect(purchases[0].final_price).to eq(0)
    end

    it 'works on null purchases' do
      expect { discount.apply([]) }.not_to raise_error
    end

    # probably not needed
    # it 'ignores nullified prices'

    context 'when target and gift is the same' do
      let(:product) { Product.new(name: 'Orange', short_name: 'ORR', price: '0.94') }
      let(:gift_product) { product }
      let(:target_product) { product }
      let(:purchases) do
        [
            Purchase.new(target_product),
            Purchase.new(gift_product),
        ]
      end

      it 'does not nullify itself' do
        expect { discount.apply(purchases) }.not_to change { purchases[0].final_price }
      end
    end

    context 'when there is no target purchases' do
      let(:purchases) { [Purchase.new(non_target_product)] }

      it 'does nothing' do
        expect { discount.apply(purchases) }.not_to change { purchases[0].final_price }
      end
    end

    context 'when multiple gifts exist' do
      let(:purchases) do
        [
            Purchase.new(gift_product),
            Purchase.new(target_product),
            Purchase.new(non_target_product),
            Purchase.new(gift_product),
        ]
      end

      it 'only gifts once' do
        discount.apply(purchases)
        expect(purchases[0].final_price).to eq(0)
        expect(purchases[3].final_price).not_to eq(0)
      end
    end
  end
end