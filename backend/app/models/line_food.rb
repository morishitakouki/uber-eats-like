# --- ここから追加 ---
class LineFood < ApplicationRecord
  belongs_to :food
  belongs_to :restaurant
  belongs_to :order, optional: true

  validates :count, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }
  scope :other_restaurant, -> (picked_restaurant_id) { where.not(restaurant_id: picked_restaurant_id) }

  def total_amount                # line_food = LineFood.active.first
    self.food.price * self.count  # line_food.food.price * line_food.count　とやってることは同じ
  end
end
  # --- ここまで追加 ---
  