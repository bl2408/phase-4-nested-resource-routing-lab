class ItemsController < ApplicationController

  def index

    if params[:user_id]

      user = User.find_by id: params[:user_id]

      if user
        render json: user.items
      else
        render json: {error: "User not found!" }, status: :not_found
      end
    
    else
      items = Item.all
      render json: items, include: :user
    end


  end

  def show

    if params[:id]

      item = Item.find_by id: params[:id]

      if item
        
        if item.user.id == params[:user_id].to_i
          render json: item, status: :ok
        else
          render json: {error: "Item not found for user! "}, status: :not_found
        end


      else
        render json: {error: "Item not found! "}, status: :not_found
      end

    end

  end


  def create
    user = User.find_by id: params[:user_id]

    if user 
      item = user.items.build(item_params)
      item.save

      render json: item, status: :created
    else
      render json: {error: "User not found! "}, status: :not_found
    end

  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

end
