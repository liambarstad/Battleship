require 'minitest/autorun'
require 'minitest/emoji'
require './lib/board'

class BoardTest < Minitest::Test

  def test_make_new_board
    board = Board.new(4)
    intended_board_hash = {"A" => {1 => " ", 2 => " ", 3 => " ", 4 => " "}, "B" => {1 => " ", 2 => " ", 3 => " ", 4 => " "}, "C" => {1 => " ", 2 => " ", 3 => " ", 4 => " "}, "D" => {1 => " ", 2 => " ", 3 => " ", 4 => " "}}
    assert_equal intended_board_hash, board.board_hash
  end

  def test_make_new_board_string
    board = Board.new(8)
    intended_board_string = ". A B C D E F G H \n1                 \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal intended_board_string, board.board_string
  end

  def test_erase_existing_board_string
    board = Board.new(8)
    board.erase_existing_board_string
    intended_board_string = ". A B C D E F G H \n"
    assert_equal intended_board_string, board.board_string
  end

  def test_update_board_string
    board = Board.new(8)
    board.board_hash["A"][3] = "H"
    board.board_hash["E"][5] = "M"
    intended_board_string = ". A B C D E F G H \n1                 \n2                 \n3 H               \n4                 \n5         M       \n6                 \n7                 \n8                 \n"
    board.update_board_string
    assert_equal intended_board_string, board.board_string
  end
end
