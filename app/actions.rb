# Homepage (Root path)
helpers do
  def current_user_nil?
    session[:user_id]
  end

  def get_current_name
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    if @current_user.nil?
      "Guest"
    else
      @current_user.display_name
    end
  end
end

get '/' do
  if @current_user.nil?
    erb :main
  else
    erb :index
  end
end

get '/login' do
  if @current_user
    redirect "/"
  else
    erb :login
  end

end

post '/login' do
  user = User.find_by(email: params[:email])
  if !user.nil? && user.password == params[:password]
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/login/error'
  end
end

get '/login/error' do
  erb :login_error
end

get "/logout" do
  session.clear
  cookies.clear
  @current_user = nil
  redirect "/"
end

get '/users/new' do
  erb :create_account
end

post '/users/new' do
  if params[:email] && params[:display_name] && params[:password] && params[:phone_number]
    user = User.new(params)
    user.password = params[:password]
    user.save
    redirect '/login'
  else
    # create a create_user error page
    redirect '/'
  end
end

get '/games/new' do
  erb :'games/new'
end

post '/games/new' do
  @game = Game.new(
    user_id: @current_user
    )
  @game.save!
  redirect '/games/:id'
end



