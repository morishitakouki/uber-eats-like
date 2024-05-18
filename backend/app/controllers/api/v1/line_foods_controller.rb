class Api::V1::LineFoodsController < ApplicationController
  before_action :set_food, only: %i[create]

  def index
    line_foods = LineFood.active
    if line_foods.exists?
      render json: {
        line_food_ids: line_foods.map {|line_food| line_food.id},
        restaurant: line_foods[0].restaurant,
        count: line_foods.sum {|line_food| line_food[:count]}
        amount: line_foods.sum {|line_food| line_food.total_amount} #各 line_food の total_amount メソッドを呼び出し、それらの値を合計しています。
      }, status: :ok 
    else 
      render json: {}, status: :no_content
    end
  end

  def create
    if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
      return render json: {
        existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name, #今注文かごに入ってるレストラン名
        new_restaurant: Food.find(params[:food_id]).restaurant.name, #新たに違うレストランの食材を仮注文した場合のその食材のレストラン名
      }, status: :not_acceptable
    end

    set_line_food(@ordered_food)

    if @line_food.save
      render json: {
        line_food: @line_food
      }, status: :created
    else
      render json: {}, status: :internal_server_error
    end
  end

  def replace
    LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
      line_food.update_attribute(:active, false)
    end

    set_line_food(@ordered_food)

    if @line_food.save
      render json: {
        line_food: @line_food
      }, status: :created
    else
      render json: {}, status: :internal_server_error
    end
  end

  private

  def set_food
    @ordered_food = Food.find(params[:food_id])
  end

  def set_line_food(ordered_food)
    #何かしらのメニューを仮注文したものに対して個数などを変更をするときの処理
    if ordered_food.line_food.present? # line_foodのdbに既にordered_foodのデータがあればそれの個数を増加させる
      @line_food = ordered_food.line_food
      @line_food.attributes = {
        count: ordered_food.line_food.count + params[:count],
        active: true
      }
    else
      #新しくメニューを仮注文(カゴに入れる)処理
      @line_food = ordered_food.build_line_food(    #ordered_food.build_line_foodでまずline_foodにfood_idだけが入る。
        count: params[:count],                      #この三つの属性の追加でプラスでカラムのレコードに追加
        restaurant: ordered_food.restaurant,
        active: true
      )
    end
  end
end
