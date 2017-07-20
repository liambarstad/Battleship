require './lib/ai'
require 'pry'

class AiPlacer < Ai::Player
  attr_accessor :ai_board, :player_board, :ships, :placed_ships
  def initialize(size, player)
    super(size)
    @player = player
    @ai_board = player.enemy_board
    @ships = [1, 1, -1, -1]
    @placed_ships = []
    initialize_big_ships
  end

  def initialize_big_ships
    if @size > 7
      @ships[2] += 2
      if @size > 11
        @ships[3] += 2
      end
    end
  end

  def find_ship_vertical(start_column, start_row, end_row_value, ship_array)
    spaces = 0
    for i in start_row..end_row_value
      ship = ship_array.select do |element|
        element.coordinates_hash.include?(start_column) && element.coordinates_hash[start_column].include?(start_row + i)
      end
      if ship.nil?
        spaces += 1
      end
    end
    return spaces
  end

  def mark_spaces_vertical(start_column, start_row, end_row_value, ship_array)
    if start_row >= end_row_value
      spaces = find_ship_vertical(start_column, end_row_value, start_row, ship_array)
    else
      spaces = find_ship_vertical(start_column, start_row, end_row_value, ship_array)
    end
    return spaces
  end

  def find_ship_horizontal(start_column, start_row, end_column_ord, ship_array)
    spaces = 0
    for i in start_column.ord..end_column_ord
      ship = ship_array.select do |element|
        element.coordinates_hash[i.chr].include?(start_row)
      end
      if ship.nil?
        spaces += 1
      end
    end
    return spaces
  end

  def mark_spaces_horizontal(start_column, start_row, end_column_ord, ship_array)
    if end_column_ord >= start_column.ord
      spaces = find_ship_horizontal(start_column, start_row, end_column_ord, ship_array)
    else
      spaces = find_ship_horizontal(end_column_ord, start_row, start_column, ship_array)
    end
    return spaces
  end

  def check_available_spaces(start_column, start_row, orientation)
    if orientation == "vertical"
      up_spaces = mark_spaces_vertical(start_column, start_row, 1, @placed_ships)
      down_spaces = mark_spaces_vertical(start_column, start_row, @size, @placed_ships)
      return up_spaces, down_spaces
    elsif orientation == "horizontal"
      right_spaces = mark_spaces_horizontal(start_column, start_row, (64 + @size), @placed_ships)
      left_spaces = mark_spaces_horizontal(start_column, start_row, 65, @placed_ships)
      return right_spaces, left_spaces
    end
  end

  def adjust_for_wiggle_room(spaces_array, ship_size)
    up_right_spaces = spaces_array[0]
    down_left_spaces = spaces_array[1]
    wiggle_room = (up_right_spaces + down_left_spaces) - ship_size
    for i in 0...wiggle_room
      choice = rand(1..2)
      if choice == 1
        up_right_spaces -= 1
      else
        down_left_spaces -= 1
      end
    end
    return up_right_spaces, down_left_spaces
  end

  def choose_vertical_or_horizontal(vertical_spaces, horizontal_spaces, ship_size)
    choice = rand(1..2)
    if choice == 1
      return [adjust_for_wiggle_room(vertical_spaces[0], vertical_spaces[1], ship_size), "V"]
    elsif choice == 2
      return [adjust_for_wiggle_room(horizontal_spaces[0], horizontal_spaces[1], ship_size), "H"]
    end
  end

  def pick_spaces(vertical_spaces, horizontal_spaces, ship_size)
    if vertical_spaces.sum >= ship_size && horizontal_spaces.sum >= ship_size
      return choose_vertical_or_horizontal(vertical_spaces, horizontal_spaces, ship_size)
    elsif vertical_spaces.sum >= ship_size
      return [adjust_for_wiggle_room(vertical_spaces[0], vertical_spaces[1], ship_size), "V"]
    elsif horizontal_spaces.sum >= ship_size
      return [adjust_for_wiggle_room(horizontal_spaces[0], horizontal_spaces[1]), "H"]
    else
      return false
    end
  end

  def spaces_from_origin_and_orientation(column_value, row_value, ship_size)
    vertical_spaces = check_available_spaces(column_value, row_value, "vertical")
    horizonal_spaces = check_available_spaces(column_value, row_value, "horizontal")
    new_spaces_and_orientation = pick_spaces(vertical_spaces, horizontal_spaces, ship_size)
    return new_spaces_and_orientation
  end

  def gather_vertical_values(row_value, up_spaces, down_spaces)
    row_values = [row_value]
    for i in 1..(down_spaces + 1)
      row_values << row_value + i
    end
    for i in 1...(up_spaces + 1)
      row_values.unshift(row_value - i)
    end
    return row_values
  end

  def gather_horizontal_values(column_value, right_spaces, left_spaces)
    column_values = [column_value]
    for i in 1..(right_spaces + 1)
      column_values << (column_value.ord + 1).chr
    end
    for i in 1..(left_spaces + 1)
      column_values.unshift((column_value.ord - 1).chr)
    end
    return column_values
  end

  def gather_space_values(column_value, row_value, up_right_spaces, down_left_spaces, orientation)
    if orientation == "V"
      row_values = gather_vertical_values(row_value, up_right_spaces, down_left_spaces)
      column_values = [column_value]
    elsif orientation == "H"
      column_values = gather_horizontal_values(column_value, up_right_spaces, down_left_spaces)
      row_values = [row_value]
    end
    return column_values, row_values
  end

  def make_new_ship(ship_size, column_values, row_values)
    @placed_ships << make_ship(@player.enemy_board, ship_size, column_values, row_values)
  end

  def place_ships
    @ships.reverse.each_with_index do |ship_marker, index|
      ship_size = 5 - index
      if ship_marker > 0
        column_value = rand(65..(64 + @size)).chr
        row_value = rand(1..@size)
        spaces_and_orientation = spaces_from_origin_and_orientation(column_value, row_value, ship_size)
        up_or_right_spaces = spaces_and_orientation[0][0]
        down_or_left_spaces = spaces_and_orientation[0][1]
        orientation = spaces_and_orientation[1]
        final_values = gather_space_values(column_value, row_value, up_or_right_spaces, down_or_left_spaces, orientation)
        make_new_ship(ship_size, final_values[0], final_values[1])
      end
    end
  end
end
