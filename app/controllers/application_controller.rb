require './config/environment'

class ApplicationController < Sinatra::Base



  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "pureguava"
  end

  get '/' do
   erb :'index'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  get '/signup' do
    if !session[:user_id]
      erb :'users/create_user'
    else
      redirect to '/slices'
    end
  end

  get '/login' do
    if !session[:user_id]
      erb :'users/login'
    else
      redirect '/slices'
    end
  end


  post '/signup' do
     if params[:username] == "" || params[:email] == "" || params[:password] == ""
       redirect to '/signup'
     else
       @user = User.create(username: params[:username], email: params[:email], password: params[:password])
       session[:user_id] = @user.id
       redirect to '/slices'
     end
   end

   post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/slices'
    else
      redirect '/signup'
    end
  end

  get '/logout' do
    if session[:user_id] != nil
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end

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
    if params[:name] == ""
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





end

#
