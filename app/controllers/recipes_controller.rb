class RecipesController < ApplicationController
    before_action :is_authenticated, only: [:index, :create]

    def index
        recipes = Recipe.all 
        render json: recipes, status: :created
    end

    def create
        user = User.find_by_id(session[:user_id])
        new_recipe = user.recipes.create!(recipe_params)
        render json: new_recipe, status: :created
    rescue ActiveRecord::RecordInvalid => invalid
        render json: { errors: [invalid.record.errors.full_messages] }, status: :unprocessable_entity
    end

    private

    def is_authenticated  
        user = User.find_by_id(session[:user_id])  
        render json: {errors: ["You need to login first"]}, status: :unauthorized unless user
    end

    def recipe_params
        params.permit(:user_id, :title, :instructions, :minutes_to_complete)
    end

end
