class Api::V1::RestaurantsController < ApplicationController
    def index
<<<<<<< HEAD
        restaurants = Restaurant.all 
       
=======
        @restaurants = Restaurant.all 


>>>>>>> 95a2e1b8f8b3297f7db27e4d791585efa770faac
        render json: {
            restaurants: @restaurants 
        }, status: :ok 
    end
end
