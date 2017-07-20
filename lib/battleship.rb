require './game'

class Battleship
  def initialize
    @player_won = 0
    @ai_won = 0
    @active_game = ""
  end

  def play_welcome_msg
    puts "WELCOME TO BATTLESHIP \n  # #  ( )
                                 ___#_#___|__
                              _  |____________|  _
                       _=====| | |            | | |==== _
                 =====| |.---------------------------. | |====
   <--------------------'   .  .  .  .  .  .  .  .   '--------------/
     \                                                             /
      \_______________________________________________WWS_________/
  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww \n"
 end

 def print_score
   if @player_won != 0 && @ai_won != 0
     puts "You have won #{@player_won} games and the AI has won #{@ai_won}"
   end
 end

 def welcome_prompt
   puts "Would you like to (p)lay, read (i)nstructions, or (q)uit?\n"
 end

 def instructions
   puts "SIZE\n- Grid sizes must be larger than 4x4"
   puts "- 4x4-7x7 will have one 2-unit boat and one 3-unit boat"
   puts "- 8x8-11x11 will have one 2-unit boat, one 3-unit boat, and one 4-unit boat\n      - 12x12 and up will have one 2-unit boat, one 3-unit boat, one 4-unit boat, and one 5-unit boat"
   puts "DIFFICULTY:\n- Easy: Enemy shots will be fired at random. For players that feel unfullfilled in their everyday existence and want to bully a bot"
   puts "- Medium: Enemy shots will continue to shoot near hit ships"
   puts "- Hard: Enemy AI will try to guess where ships are based on possible positions and the number and type of ships sunk"
   puts "PLACING SHIPS:\n- After the AI has placed their ships, you will be instructed to place your ships in order from largest to smallest, when asked to give tile coordinates, make sure that they are in the form 'XY', where X is any legal letter coordinate and Y is any legal number coordinate. When listing multiple tile values, remember to include spaces in between them."
   puts "MAIN PHASE:\n- If the difficulty is set at easy or medium, the player will go first. If the difficulty is hard, the AI will go first. During your turn, a board will be displayed containing all guesses and their results that you have made so far. At this point, you may either type in a guess in the form 'XY', or see your own board by typing in '@' and pressing ENTER. After viewing your own board, press ENTER to return to the guess screen."
   puts "VICTORY:\n Once either all of your or all of your opponent's battleships are sunk, the game will end."
   puts "Press ENTER to return to main screen"
 end

 def instruction_prompt
   instructions
   gets.chomp
   return 42
 end

 def main_menu
   welcome_prompt
   ans = gets.chomp
   case ans
   when "p" || "P"
     initialize_new_game
   when "i" || "I"
     instruction_prompt
     main_menu
   when "q" || "Q"
     exit(1)
   else
     puts "Invalid input"
     main_menu
   end
 end


 def check_legal_size(size)
   if size > 3 return true
   else return false
   end
 end

 def size_prompt
   puts "Enter game board size:"
   ans = gets.chomp
   return ans.to_i
 end

 def check_legal_difficulty(ans)
   if ans == "E" || ans == "M" || ans == "H"
     return ans
   elsif ans == "e" || ans == "m" || ans == "h"
     return ans.upcase
   else
     return false
   end
 end

 def difficulty_prompt
   puts "Enter AI difficulty level (E/M/H)"
   ans = gets.chomp
   return check_legal_difficulty(ans)
 end

 def set_ai_difficulty
   are_you_stupid = true
   while are_you_stupid == true
     ai_difficulty = difficulty_prompt
     if !(ai_difficulty == false)
       are_you_stupid == false
     end
   end
   return ai_difficulty
 end

 def make_game(game_size, ai_difficulty)
   while are_you_stupid_pt_2 == true
     if check_legal_size(game_size)
       @active_game = Game.new(game_size, ai_difficulty)
       are_you_stupid_pt_2 = false
     end
   end
 end

 def initialize_new_game
   game_size = size_prompt
   ai_difficulty = set_ai_difficulty
   are_you_stupid_pt_2 = true
   make_game(game_size, ai_difficulty)
 end

 def run_game
   @active_game.placing_phase
   player_won = @active_game.main_phase
   if player_won == true {@player_won += 1}
   else
     @ai_won += 1
   end
 end
end
