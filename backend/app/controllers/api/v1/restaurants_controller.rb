class Api::V1::RestaurantsController < ApplicationController
    def index
        @restaurants = Restaurant.all
        puts "restaurantsには#{@restaurants.inspect}です"

        render json: {
            restaurants: @restaurants 
        }, status: :ok 
    end
end
