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


  post '/signup' do
     if params[:username] == "" || params[:email] == "" || params[:password] == ""
       redirect to '/signup'
     else
       @user = User.create(username: params[:username], email: params[:email], password: params[:password])
       session[:user_id] = @user.id
       redirect to '/slices'
     end
   end

   get '/slices' do
     if !session[:user_id]
        redirect to '/signup'
      else
        erb :'/slices/slices'
      end
   end


end
