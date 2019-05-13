# Get specified gift for purchasing target product
class GiftForTargetDiscount
  attr_reader :target_short_name, :gift_short_name

  def initialize(target_short_name, gift_short_name)
    @target_short_name = target_short_name.to_sym
    @gift_short_name = gift_short_name.to_sym
  end

  def apply(purchases)
    # Hacky but works
    if target_short_name == gift_short_name
      apply_same_short_names(purchases)
    else
      apply_different_short_names(purchases)
    end
  end

  private

  def apply_same_short_names(purchases)
    purchases
        .select { |purchase| purchase.product.short_name == target_short_name }
        .each_slice(2)
        .each { |pair_of_targets| pair_of_targets[1]&.final_price = 0 }
  end

  def apply_different_short_names(purchases)
    # Select our target product
    # and give each target gift
    all_targets = purchases.select { |purchase| purchase.product.short_name == target_short_name }

    all_targets.each do
      purchases
          .find { |purchase| purchase.product.short_name == gift_short_name }
          .final_price = 0
    end
  end
end