require './lib/ship'

class Board
  attr_accessor :size, :board_hash, :board_string, :ships
   def initialize(size)
     @size = size
     @board_hash = make_new_board
     @board_string = ""
     make_new_board_string
     @ships = []
   end

   def make_new_board
     board_hash = Hash.new
     for i in 0..(@size - 1)
       column_value = (65 + i).chr
       board_hash.store(column_value, {})
       for i in 1..@size
         board_hash[column_value].store(i, " ")
       end
     end
     board_hash
   end

   def make_new_board_string
     @board_string = ". "
     board_hash.keys.each do |column_value|
       @board_string += column_value + " "
     end
     @board_string += "\n"
     update_board_string
   end

   def erase_existing_board_string
     @board_string.slice!(((@size * 2) + 3)..(board_string.length - 1))
   end

   def update_board_string
     erase_existing_board_string
     for i in 1..@size
       @board_string += i.to_s + " "
       @board_hash.values.each do |nested_hash|
         @board_string += nested_hash[i] + " "
       end
       @board_string += "\n"
     end
   end

   def make_new_ship(size, column_values, row_values)
     ship = Ship.new(size, column_values, row_values)
     if !(ship.coordinates_hash.empty?)
       @ships << ship
     end
   end

   def check_if_hit(column_value, row_value)
    hit_ship = @ships.find do |ship|
      ship.coordinates_hash.include?(column_value) && ship.coordinates_hash[column_value].include?(row_value)
    end
    if !(hit_ship.nil?)
      hit_ship
    else
      false
    end
  end

  def mark_hit(column_value, row_value)
    @board_hash[column_value][row_value] = "H"
    update_board_string
  end

  def mark_miss(column_value, row_value)
    @board_hash[column_value][row_value] = "M"
    update_board_string
  end

  def mark_ships
    @ships.each do |ship|
      ship.coordinates_hash.each do |key, value|
        value.each do |number, space|
          @board_hash[key][number] = "S"
        end
      end
    end
    update_board_string
  end
end
