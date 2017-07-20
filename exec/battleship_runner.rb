battleship = Battleship.new
continue = true
while continue == true
  battleship.play_welcome_msg
  battleship.print_score
  battleship.main_menu
  battleship.run_game
  puts "Would you like to play again?"
  ans = gets.chomp
  if ans != "Y" && ans != "y"
    continue == false
  end
end
