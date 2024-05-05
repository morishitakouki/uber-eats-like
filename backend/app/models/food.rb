# --- ここから追加 ---
class Food < ApplicationRecord
    belongs_to :restaurant
    has_one :line_food
  end
  # --- ここまで追加 ---
  