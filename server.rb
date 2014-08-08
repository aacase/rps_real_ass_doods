require 'bundler'
Bundler.require

# load the Database and User model
require './model'

class SinatraWardenExample < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  use Warden::Manager do |config|
    # Tell Warden how to save our User info into a session.
    # Sessions can only take strings, not Ruby code, we'll store
    # the User's `id`
    config.serialize_into_session{|user| user.id }
    # Now tell Warden how to take what we've stored in the session
    # and get a User from that information.
    config.serialize_from_session{|id| User.get(id) }

    config.scope_defaults :default,
      # "strategies" is an array of named methods with which to
      # attempt authentication. We have to define this later.
      strategies: [:password],
      # The action is a route to send the user to when
      # warden.authenticate! returns a false answer. We'll show
      # this route below.
      action: 'auth/unauthenticated'
    # When a user tries to log in and cannot, this specifies the
    # app to send the user to.
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user'] && params['user']['username'] && params['user']['password']
    end

    def authenticate!
      user = User.first(username: params['user']['username'])

      if user.nil?
        fail!("The username you entered does not exist.")
      elsif user.authenticate(params['user']['password'])
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    erb :signup
  end

  post '/signup' do
    
    @newu = params['username']
    @newpass=params['password']
    @user = User.create(username: @newu)
    @user.password = @newpass
    @user.save
    
  end

  get '/auth/login' do
    erb :login
  end

  post '/auth/login' do
    env['warden'].authenticate!
    @currentuser=session["warden.user.default.key"]
    
    flash[:success] = env['warden'].message

    if session[:return_to].nil?

      redirect "/userview/#{@currentuser}"
    else
      redirect session[:return_to]
    end
  end

  get '/auth/logout' do
    env['warden'].raw_session.inspect
   
    env['warden'].logout
    
    flash[:success] = 'Successfully logged out'
    # redirect '/'
  end

  get '/userview/:id' do

    if session["warden.user.default.key"]==params["id"].to_i
      @active_matches = Match.all(:user1=> params["id"].to_i, :winner =>"0" )#get active matches
      @active_matches2 = Match.all(:user2=> params["id"].to_i, :winner =>"0" )#get active matches
      @completed_matches = Match.all(:user1=> params["id"].to_i, :winner =>"1") #get completed matches
      @completed_matches2 = Match.all(:user2=> params["id"].to_i, :winner =>"1") #get completed matches
      # binding.pry

      erb :userview
    else 
      redirect '/'
    end
    
  end

  post '/auth/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
    puts env['warden.options'][:attempted_path]
    puts env['warden']
    flash[:error] = env['warden'].message || "You must log in"
    redirect '/auth/login'
  end

  get '/protected' do
    env['warden'].authenticate!


    erb :protected
  end

  get "/auth/challenge" do 
    env['warden'].raw_session.inspect
    erb :challenge
  end

  post "/auth/challege" do
    @challenge_match = Match.create(user1: 4, user2: 9)
    @challenge_game = 
  end

  post "/auth/rock_submit_primary" do # submit button that updates sql table to reflect move
    env['warden'].authenticate!
    @newmatch= Match.all(:user1=> session["warden.user.default.key"])
    binding.pry
    #how do we get the user 2 id here?
    
    @new_game= Game.create(match_id: @newmatch.first.id, user1_choice: "rock")
    #this will cause bugs with multiple matches open.
    erb :index

  end

  post "/auth/rock_submit_secondary" do # submit button that updates sql table to reflect move
    env['warden'].authenticate!
    @newmatch= Match.all(:user2=> session["warden.user.default.key"])
    binding.pry
    
    
    @new_game= Game.all(match_id: @newmatch.first.id, user2_choice:"rock")
    #this will cause bugs with multiple matches open.
    erb :index

  end

  post "/auth/paper_submit_primary" do # submit button that updates sql table to reflect move
    env['warden'].authenticate!
    @newmatch= Match.all(:user1=> session["warden.user.default.key"])
    binding.pry
    #how do we get the user 2 id here?
    
    @new_game= Game.create(match_id: @newmatch.first.id, user1_choice: "paper", user2_choice:"null for now")
    #this will cause bugs with multiple matches open.
    erb :index

  end

  post "/auth/paper_submit_secondary" do # submit button that updates sql table to reflect move
    env['warden'].authenticate!
    @newmatch= Match.all(:user2=> session["warden.user.default.key"])
    binding.pry
    
    
    @new_game= Game.create(match_id: @newmatch.first.id, user2_choice:"paper")
    #this will cause bugs with multiple matches open.
    erb :index

  end

  post "/auth/scissors_submit_primary" do # submit button that updates sql table to reflect move
    env['warden'].authenticate!
    @newmatch= Match.all(:user1=> session["warden.user.default.key"])
    binding.pry
    #how do we get the user 2 id here?
    
    @new_game= Game.create(match_id: @newmatch.first.id, user1_choice: "scissors", user2_choice:"null for now")
    #this will cause bugs with multiple matches open.
    erb :index

  end

  post "/auth/scissors_submit_secondary" do # submit button that updates sql table to reflect move
    env['warden'].authenticate!
    @newmatch= Match.all(:user2=> session["warden.user.default.key"])
    binding.pry
    
    
    @new_game= Game.get(match_id: @newmatch.first.id)
    binding.pry
    #this will cause bugs with multiple matches open.
    erb :index

  end




end