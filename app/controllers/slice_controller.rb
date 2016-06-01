class SliceController < ApplicationController
  
  

  get '/slices' do
    if !session[:user_id]
        redirect to '/signup'
      else
        erb :'/slices/slices'
      end
   end

   get '/slices/new' do
    if !session[:user_id]
      redirect to 'login'
    else
      erb :'/slices/create_restaurant'
    end
  end



  post '/slices' do
    if params[:name] == "" || params[:city] == "" || params[:rating] == ""
      flash[:message] = "* Marked Fields May Not Be Empty. Please Try Again."
      redirect to "/slices/new"
    else
      user = User.find_by_id(session[:user_id])
      @restaurant = Restaurant.create(name: params[:name], address: params[:address], city: params[:city], rating: params[:rating], user_id: user.id)
      redirect to "/slices/#{@restaurant.id}"
    end
   end


   get '/slices/:id' do
       if !session[:user_id]
         redirect to '/login'
       else
         @restaurant = Restaurant.find_by_id(params[:id])
         erb :'slices/show_restaurant'
       end
     end

   get '/slices/:id/edit' do
     if !session[:user_id]
       redirect to '/login'
     else
       @restaurant = Restaurant.find_by_id(params[:id])
         if @restaurant.user_id == session[:user_id]
           erb :'slices/edit_restaurant'
         else
           redirect to '/slices'
         end
      end
    end


    patch '/slices/:id' do
      if params[:name] == "" || params[:city] == "" || params[:rating] == ""
        flash[:message] = "* Marked Fields May Not Be Empty. Please Try Again."
        redirect to "/slices/#{params[:id]}/edit"
      else
        @restaurant = Restaurant.find_by_id(params[:id])
        @restaurant.name = params[:name]
        @restaurant.address = params[:address]
        @restaurant.city = params[:city]
        @restaurant.rating = params[:rating]
        @restaurant.save(name: params[:name], address: params[:address], city: params[:city], rating: params[:rating])
        redirect to "/slices/#{@restaurant.id}"
       end
    end


    delete '/slices/:id/delete' do
      @user = current_user
      @restaurant = Restaurant.find(params[:id])
      if !current_user.restaurants.ids.include?(@restaurant.id)
        redirect to "/slices"
      else
        @restaurant.delete
        redirect to '/slices'
      end
    end


end
