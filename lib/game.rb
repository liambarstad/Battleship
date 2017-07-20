require './lib/player'

 class Game
   def initialize(size, difficulty)
     @size = size
     @player = Player.new(size)
     @ai = Ai.new(size, @player, difficulty)
     @ships = [1, 1, 0, 0]
     initialize_big_ships
   end

   def initialize__big_ships
     if @size > 7
       @ships[2] += 1
       if @size > 11
         @ships[3] += 1
       end
     end
   end

   def num_spelled_out(num)
     case num
     when 2 return "two"
     when 3 return "three"
     when 4 return "four"
     when 5 return "five"
     end
   end

   def placing_init_text
     puts "I have laid out my ships on the grid"
     puts "You now need to layout your #{num_spelled_out(@ships.sum)} ships"
     puts "The first is two units long#{@ships[2] == 0? ' and' : ','} the second is three units long"
     if @ships[2] == 1
       print "#{@ships[3] == 0? ' and' : ','} the third is four units long"
     end
     if @ships[3] == 1
       print " and the fourth is five units long"
     end
     puts "The grid has A1 at the top left and #{(65 + (@size - 1)).chr}#{size} at the bottom right"
   end

   def player_place_ship(ship_index)
     rep = false
     until rep == true
       puts "\nEnter the squares for the #{ship_index + 2} unit ship"
       ans = gets.chomp
       rep = player.place_ship(player.friendly_board, (index + 2), ans)
     end
   end

   def player_placing_phase
     placing_init_text
     @ships.each_with_index do |ship, index|
       if ship == 1
         player_place_ship(index)
       end
     end
     @player.friendly_board.mark_ships
   end

   def placing_phase
     @ai.place_ships
     player_placing_phase
   end

   def player_board
     @player.friendly_board.board_string
   end

   def ai_board
     @player.enemy_board.board_string
   end

   def hit_prompt
     puts "ENEMY SHIP HIT!\npress ENTER to continue"
     gets.chomp
   end

   def miss_prompt
     puts "--miss--\npress ENTER to continue"
     gets.chomp
   end

   def sunk_prompt
     puts "ENEMY SHIP HIT AND SUNK!!\npress ENTER to continue"
     gets.chomp
   end

   def interpret_guess_result(result)
     if result == "S"
       sunk_prompt
     elsif result == "H"
       hit_prompt
     elsif result == "M"
       miss_prompt
     else
       puts "Invalid coordinates"
       return false
     end
   end

   def player_turn_prompt
     made_guess = false
     while made_guess == false
       puts "Enter the coordinates of the square you'd like to attack (@ to view player board)"
       ans = gets.chomp
       result = @player.make_guess(ai_board, ans)
       end
       repeat = interpret_guess_result(result)
       if repeat != false {made_guess = true}
     end
   end

   def ai_turn_prompt
     puts player_board
     if @ai.last_result == "S"
       puts "COMPUTER HAS SUNK A BATTLESHIP!!! last guess: #{ai.last_guess}"
     elsif @ai.last_result == "H"
       puts "Computer has hit a battleship at #{ai.last_guess}!!"
     else
       puts "Computer missed at #{ai.last_guess}!"
     end
     puts "Press ENTER to continue"
     gets.chomp
   end

   def check_if_player_won
     player.enemy_board.ships.all? do |ship|
       ship.sunk == true
     end
   end

   def check_if_ai_won
     player.friendly_board.ships.all? do |ship|
       ship.sunk == true
     end
   end

   def end_msg_player
     puts "CONGRATULATIONS, YOU WON!!"
   end

   def end_msg_ai
     puts "You have lost"
   end

   def end_prompt(player_won, ai_won)
     if player_won == true
       end_msg_player
     else
      end_msg_ai
    end
  end

   def easy_med_main_phase
     player_won = false
     ai_won = false
     until player_won == true || ai_won == true
       player_turn_prompt
       player_won = check_if_player_won
       if player_won == false
         ai.attack
         ai_turn_prompt
       end
     end
     end_prompt(player_won, ai_won)
     return player_won
   end

   def difficult_main_phase
     player_won = false
     ai_won = false
     until player_won == true || ai_won == true
       ai.attack
       ai_turn_prompt
       if player_won == false
         player_turn_prompt
         player_won = check_if_player_won
       end
     end
     end_prompt(player_won, ai_won)
     return player_won
   end

   def main_phase
     if @difficulty == "E" || @difficulty == "M"
       return easy_med_main_phase
     else
       return difficult_main_phase
     end
   end
