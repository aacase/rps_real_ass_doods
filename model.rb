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
  property :winner_id, Integer
  property :winner, String, length: 20
  property :user1_wins, Integer
  property :user2_wins, Integer
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
      match.update(:winner_id => @winner, :winner => "1")
    elsif match.user2_wins >= 3
      @winner=match.user2
      match.update(:winner_id => @winner, :winner => "1")
    else
      nil
    end
    
    # @match=Match.get(:match_id= match)
    # @win1  = Match.all(:user1_wins => "3")
    # @win2 = Match.all(:user2_wins => "3")
    # if @win1.count >= 3
    # elsif 
    # else
    #   return nil;
    # end

  end

  # def self.primary_match_history(match)
  #   mh = Game.all(:match_id => match.id)
    
  #   @stuff="no previous moves"


  #     if mh.count == 1
  #       @stuff
  #     elsif mh.count ==2
  #        @stuff="1. #{mh[-2].user1_choice}"
  #     else
  #        @stuff= "1.#{mh[-2].user1_choice}  2.#{mh[-3].user1_choice}"
         
  #     end
  #     # binding.pry
  # end

  # def self.update_user_wins(match)
  #   match.
  # end

end

class Game
  include DataMapper::Resource

  property :id, Serial, key:true
  property :match_id, Integer
  property :user1_choice, String, length: 20
  property :user2_choice, String, length: 20
  property :winner, Integer
  
  def self.find_games(match_id)
    Game.all(:match_id => match_id)
  end

  def self.active_game?(match)
    # binding.pry
    games = Game.all(:match_id => match.id)
    # last=games.last
    if games.last.user2_choice == nil && games.last.user1_choice== nil
      games.last
    else
      nil
    end
  end

  def self.user1_played?(match)
    games = Game.all(:match_id => match.id)
    if games.last.user1_choice != nil
      true
    else
      false
    end
  end

  def self.beats(p1_move, p2_move)
    beats={"scissors" => "rock",
            "paper" => "scissors",
            "rock" => "paper"}


    if p1_move== beats[p2_move]
      "p1"
    elsif p2_move==beats[p1_move]
      "p2"
    else 
      "tie"
    end
  end

  def self.declare_winner(match)
    # conti
    game = Game.all(:match_id => match.id).last
    
    p1_move = game.user1_choice
    p2_move = game.user2_choice
    winner = Game.beats(p1_move, p2_move)

    if winner == "p1"
      game.update(:winner => match.user1)
      user1_wins = Match.get(match.id).user1_wins + 1
      match.update(:user1_wins => user1_wins)
    elsif winner == "p2"
      game.update(:winner => match.user2)
      user2_wins = Match.get(match.id).user2_wins + 1
      match.update(:user2_wins => user2_wins)
    else
      game.destroy
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





