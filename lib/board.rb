# require './lib/ship'
require 'pry'

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

   def make_new_board_string
     @board_string = ". "
     board_hash.keys.each do |column_value|
       @board_string += column_value + " "
     end
     @board_string += "\n"
     update_board_string
   end

  #  def make_new_ship
   #
  #  end

   def check_if_hit(row_value, column_value)
    hit_ship = @ships.find_by do |ship|
      ship.coordinates_hash.include?(column_value) && ship.coordinates_hash[column_value].include?(row_value)
    end
    if !(hit_ship.nil?)
      true
    else
      false
    end
  end
end
