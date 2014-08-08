require 'bcrypt'
require 'RPS'
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db.sqlite")

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, key: true
  property :username, String, length: 128
  property :password, BCryptHash
  property :match_wins, Integer

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
end

# user = User.get(:username => )

class Match
  include DataMapper::Resource

  property :id, Serial, key:true 
  property :user1, Integer
  property :user2, Integer
  property :winner, String, length: 20
  # property :pending, Boolean :default => true

  # def self.deny(match)

  #    = Match.get(match_id: match.id)
  #   binding.pry
   
  #   games.destroy
  #   binding.pry

  #   match.destroy
  # end



end

class Game
  include DataMapper::Resource

  property :id, Serial, key:true
  property :match_id, Integer
  property :user1_choice, String, length: 20
  property :user2_choice, String, length: 20
end

# Tell DataMapper the models are done being defined
DataMapper.finalize

# Update the database to match the properties of User.
DataMapper.auto_upgrade!

# Create a test User
if User.count == 0
  @user = User.create(username: "aaron")
  @user.password = "aaron"
  @user.save
end

if Match.count == 0
  @match = Match.create(user1: 4, user2: 9)
  @match2= Match.create(user1: 5, user2: 10)
  @match2= Match.create(user1: 12 , user2: 13)
  @game=Game.create(match_id: @match.id, user1_choice: "rock", user2_choice: "nil")
  
  
  @game.save



  # @match.user1=4
  # @match.user2=9
  # # binding.pry
  # @match.save
end





