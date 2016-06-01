require './config/environment'

class ApplicationController < Sinatra::Base



  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    use Rack::Flash
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
       flash[:message] = "*You must enter a username, email and password. Please try again."
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
      flash[:message] = "*Username or Password does not match our records. Please try again."
      redirect '/login'
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



     



end
