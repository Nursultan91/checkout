require 'product'

describe Product do
  describe '#new' do
    let(:attributes) do
      {
          name: :Potato,
          short_name: 'PO',
          price: '1.50'
      }
    end

    let(:expected_attributes) do
      {
          name: 'Potato',
          short_name: :PO,
          price: BigDecimal('1.50')
      }
    end

    it 'accepts correct attributes' do
      expect(described_class.new(attributes)).to have_attributes(expected_attributes)
    end
  end
end