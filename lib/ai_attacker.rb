class AiAttacker < AiPlacer::Ai::Player
  attr_accessor :square_array, :last_result
  def initialize(size, player, difficulty)
    super(size, player)
    @difficulty = difficulty
    @player_board = player.friendly_board
    @square_array = create_square_array
    @priority_4 = []
    @priority_3 = []
    @priority_2 = []
    @priority_1 = []
    @last_guess = ""
    @last_result = ""
  end

  def create_square_array
    arr = []
    for i in 0..(@size - 1)
      for j in 1..@size
        element = (65 + i).chr + j.to_s
        arr << element
      end
    end
    return arr
  end

  def clear_priorities
    @priority_4.clear
    @priority_3.clear
    @priority_2.clear
    @priority_1.clear
  end

  def push_priority(surrounding_array)
    surrounding_array.map_with_index do |square, index|
      if !(check_guess_legal(square))
        surrounding_array.slice!(index)
      end
      sort_by_priority(square)
    end
  end

  def interpret_after_hit
    if @last_result = "H"
      clear_priorities
      temporary_surroundings = []
      temporary_surroundings << (@last_guess[0] + (@last_guess[1].to_i - 1).to_s)
      temporary_surroundings << (@last_guess[0] + (@last_guess[1].to_i + 1).to_s)
      temporary_surroundings << ((@last_guess.ord + 1).chr + @last_guess[1])
      temporary_surroundings << ((@last_guess.ord - 1).chr + @last_guess[1])
      push_priority(temporary_surroundings)
    end
  end

  def find_smallest_remaining_ship_size
    index = @ships.find_index do |num|
      num == 1
    end
    return index + 2
  end

  def sort_by_priority(square)
    vertical = check_available_spaces(square[0], square[1].to_i, "vertical")
    horizontal = check_available_spaces(square[0], square[1].to_i, "horizontal")
    smallest_ship = find_smallest_remaining_ship_size
    if vertical.sum >= smallest_ship && horizontal.sum >= smallest_ship && (vertical[0] == 0 || vertical[1] == 0 || horizontal[0] == 0 || horizontal[1] == 0)
      @priority_3 << square
    elsif vertical.sum >= smallest_ship && horizontal.sum >= smallest_ship
      @priority_4 << square
    elsif (vertical.sum >= smallest_ship || horizontal.sum >= smallest_ship) && (vertical[0] == 0 || vertical[1] == 0 || horizontal[0] == 0 || horizontal[1] == 0)
      @priority_1 << square
    elsif vertical.sum >= smallest_ship || horizontal.sum >= smallest_ship
      @priority_2 << square
    end
  end

  def priorities_empty?
    if @priority_4.empty? && @priority_3.empty? && @priority_2.empty? && @priority_1.empty?
      return true
    else return false
    end
  end

  def get_random_element(arr)
    random_index = rand(0..(arr.length - 1))
    return arr[random_index]
  end

  def easy_attack
    return get_random_element(@square_array)
  end

  def prioritized_attack
    if !(@priority_4.empty?)
      return get_random_element(@priority_4)
    elsif !(@priority_3.empty?)
      return get_random_element(@priority_3)
    elsif !(@priority_2.empty?)
      return get_random_element(@priority_2)
    else
      return get_random_element(@priority_1)
    end
  end

  def interpret_results
    interpret_after_hit
    if @last_result == "S"
      ship = find_ship_vertical(@last_guess[0], @last_guess[1].to_i, @last_guess[1].to_i, @player_board)
    end
    @ships[ship.size - 2] -= 1
  end

  def difficult_attack
    if @last_result != "H"
      @square_array.each do |square|
        sort_by_priority(square)
      end
    end
    @last_guess = prioritized_attack
  end

  def fire_torpedos
    @last_result = make_guess(@player_board, @last_guess)
    interpret_results
    @square_array.delete(@last_guess)
  end

  def ai_attack
    if @difficulty == "E" || @difficulty == "M" || priorities_empty?
      @last_guess = easy_attack
    else
      difficult_attack
    end
    fire_torpedos
  end
end
