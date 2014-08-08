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

  def self.find_id_by_name(name)
    user = User.all(:username => name)
    user.first.id
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
  def self.declare_winner(match)
    #game.all(matchid AND user1)
    if match.user1_wins >= 3
      @winner=match.user1
    elsif match.user2_wins >= 3
      @winner=match.user2
    else
      nil
    end
    match.update(:winner_id => @winner, :winner => "1")
    # @match=Match.get(:match_id= match)
    # @win1  = Match.all(:user1_wins => "3")
    # @win2 = Match.all(:user2_wins => "3")
    # if @win1.count >= 3
    # elsif 
    # else
    #   return nil;
    # end

  end

  def self.update_user_wins(match)
    match.
  end

end

class Game
  include DataMapper::Resource

  property :id, Serial, key:true
  property :match_id, Integer
  property :user1_choice, String, length: 20
  property :user2_choice, String, length: 20
  
  def self.find_games(match_id)
    Game.all(:match_id => match_id)
  end

  def self.active_game?(match)
    games = Game.all(:match_id => match.id)
    if games.last.user2_choice == nil
      games.last
    else
      nil
    end
  end

  def self.beats(p1_move, p2_move)
    beats={"scissors" => "paper",
            "paper" => "rock",
            "rock" => "scissors"}


    if p1_move== beats[p2_move]
      "p1"
    elsif p2_move==beats[p1_move]
      "p2"
    else 
      "tie"
    end
  end

  def self.declare_winner(match)
    game = Game.active_game?(match)
    p1_move = game.user1_choice
    p2_move = game.user2_choice
    winner = Game.beats(p1_move, p2_move)

    if winner == "p1"
      game.update(:winner => match.user1)
      user1_wins = match.get(:user1_wins).to_i + 1
      match.update(:user1_wins => user1_wins.to_s)
    elsif winner == "p2"
      game.update(:winner => match.user2)
      user2_wins = match.get(:user2_wins).to_i + 1
      match.update(:user2_wins => user2_wins.to_s)
    else

    end

  end

end

# Tell DataMapper the models are done being defined
DataMapper.finalize

# Update the database to match the properties of User.
DataMapper.auto_upgrade!


# # Create a test User
# if User.count == 0
#   @user = User.create(username: "aaron")
#   @user.password = "aaron"
#   @user.save
# end

# if Match.count == 0
#   @match = Match.create(user1: 4, user2: 9)
#   @match2= Match.create(user1: 5, user2: 10)
#   @match2= Match.create(user1: 12 , user2: 13)
#   @game=Game.create(match_id: @match.id, user1_choice: "rock", user2_choice: "nil")
  
  
#   @game.save



#   # @match.user1=4
#   # @match.user2=9
#   # # binding.pry
#   # @match.save
# end





