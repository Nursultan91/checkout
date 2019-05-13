require 'mass_group_discount'
require 'product'
require 'purchase'

describe MassGroupDiscount do
  describe '#apply' do
    let(:discount) do
      described_class.new(
          target_short_name: target_short_name,
          amount_threshold: amount_threshold,
          discount: discount_amount
      )
    end
    let(:target_product) { Product.new(name: 'Potato', short_name: 'PO', price: '1.5') }
    let(:non_target_product) { Product.new(name: 'Tomato', short_name: 'TO', price: '0.3') }
    let(:target_short_name) { target_product.short_name }
    let(:amount_threshold) { 3 }
    let(:discount_amount) { BigDecimal(10) }
    let(:purchases) do
      [
          Purchase.new(target_product),
          Purchase.new(non_target_product),
          Purchase.new(target_product),
          Purchase.new(target_product),
      ]
    end

    it 'gives discount for each when amount is reached' do
      discount.apply(purchases)

      purchases.select { |purchase| purchase.product == target_product }.each do |purchase|
        expect(purchase.final_price.to_f).to eq(1.35)
      end
    end

    it 'works on null purchases' do
      expect { discount.apply([]) }.not_to raise_error
    end

    # probably not needed
    # it 'ignores nullified prices'

    context 'when there is no target purchases' do
      let(:purchases) { [Purchase.new(non_target_product)] }

      it 'does nothing' do
        expect { discount.apply(purchases) }.not_to change { purchases[0].final_price }
      end
    end
  end
end
