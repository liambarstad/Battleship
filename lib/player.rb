require './lib/board'

class Player
  attr_accessor :size, :enemy_board, :friendly_board
  def initialize(size)
    @size = size
    @enemy_board = Board.new(size)
    @friendly_board = Board.new(size)
  end

  def string_to_coordinates(ship_string)
    placement = ship_string.split
    column_values = Array.new
    row_values = Array.new
    placement.each do |place|
      column_values << place[0]
      row_values << place[1].to_i
    end
    return column_values, row_values
  end

  def ship_nonexist?(ship)
    if ship.nil?
      return true
    else
      return false
    end
  end

  def check_if_overlap(column_values, row_values)
    ship = @friendly_board.ships.find do |ship|
      column_values.each do |cv|
        row_values.each do |rv|
          ship.coordinates_hash.include?(cv) && ship.coordinates_hash.values.include?(rv)
        end
      end
    end
    return ship_nonexist?(ship)
  end

  def make_ship(board, size, column_values, row_values)
    if !(check_if_overlap(column_values, row_values))
      prev_count = board.ships.count
      board.make_new_ship(size, values[0], values[1])
      after_count = board.ships.count
      if prev_count == after_count
        return true
      else
        return false
      end
    else
      return false
    end
  end

  def place_ship(board, size, ship_string)
    values = string_to_coordinates(ship_string)
    return make_ship(board, size, values[0], values[1])
  end

  def player_board
    @friendly_board.board_string
  end

  def ai_board
    @enemy_board.board_string
  end

  def check_guess_legal?(guess_string)
    if guess_string[0].ord < 65 + @size && guess_string[0].ord > 64
      if guess_string[1].to_i <= @size && guess_string[1].to_i
        return true
      else return false
      end
    else return false
    end
  end

  def get_first_coordinate(guess_string)
    coordinates = guess_string.split.first
    return coordinates
  end

  def mark_sunk(ship, board)
    ship.coordinates_hash.each do |cv|
      cv[0].each do |rv|
        board.coordinates_hash[cv][rv] = "X"
      end
    end
    board.update_board_string
  end

  def check_if_sunk(ship, board)
    ship_sunk = ship.check_if_sunk
    if ship_sunk == true
      return "S"
      mark_sunk(ship, board)
    else
      return "H"
    end
  end

  def interpret_guess(board, ship, coordinates)
    if ship != false
      board.mark_hit(coordinates[0], coordinates[1])
      return check_if_sunk(ship, board)
    else
      board.mark_miss(coordinates[0], coordinates[1])
      return "M"
    end
  end

  def make_guess(board, guess_string)
    if check_guess_legal?(guess_string)
      coordinates = get_first_coordinate(guess_string)
      ship = board.check_if_hit
      if ship != false
        ship.coordinates_hash[coordinates[0]][0][coordinates[1]] = "H"
      return interpret_guess(board, ship, coordinates)
      end
    else
      return false
    end
  end
end
