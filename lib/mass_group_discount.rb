# Group discount for each when passing certain amount
class MassGroupDiscount
  attr_reader :target_short_name, :amount_threshold, :discount

  def initialize(target_short_name:, amount_threshold:, discount:)
    @target_short_name = target_short_name
    @amount_threshold = amount_threshold
    @discount = (100 - BigDecimal(discount)) / 100
  end

  def apply(purchases)
    all_targets = purchases.select { |purchase| purchase.product.short_name == target_short_name }
    return unless all_targets.count == amount_threshold
    all_targets.each { |target| target.final_price = (target.final_price * discount) }
  end
end
