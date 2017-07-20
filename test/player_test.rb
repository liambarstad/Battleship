require './lib/player'
require 'minitest/autorun'
require 'minitest/emoji'

class PlayerTest < Minitest::Test
  def test_string_to_coordinates
    player = Player.new(12)
    coordinates = player.string_to_coordinates("A1")
    assert_equal [["A"], [1]], coordinates
  end

  def test_ship_nonexist
    player = Player.new(12)
    ship = Ship.new(2, ["A"]. [1, 2])
    refute player.ship_nonexist?(ship)
  end

  def test_check_if_overlap_with_ship
    player = Player.new(12)
    player.friendly_board.ships << Ship.new(["A"], [1, 2])
    ship = player.check_if_overlap(["A"], [1])
    refute ship
  end

  def test_check_if_overlap_without_ship
    player = Player.new(12)
    player.friendly_board.ships << Ship.new(["A"], [1, 2])
    ship = player.check_if_overlap(["B"], [1, 4])
    assert ship
  end

  def test_make_new_ship
    player = Player.new(12)
    exist = player.make_ship(player.friendly_board, 3, ["A", "B", "C"], [3])
    assert exist
  end

  def test_make_new_illegal_ship
    player = Player.new(12)
    exist = player.make_ship(player.friendly_board, 3, ["A", "C", "D"], 7)
    refute exist
  end

  def test_place_ship
    player = Player.new(12)
    exist = player.place_ship(player.friendly_board, 3, "A1, A2, A3")
    assert exist
  end

  def test_check_guess_legal_true
    player = Player.new(12)
    legal = check_guess_legal?("A1")
    assert legal
  end

  def test_check_guess_legal_false
    player = Player.new(12)
    legal = check_guess_legal?("Z2")
    refute legal
  end

  def test_get_first_coordinate
    player = Player.new(12)
    coordinate = player.get_first_coordinate("A1, A2, A3")
    assert equal "A1,", coordinate
  end

  def test_mark_sunk
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [1, 2, 3])
    player.mark_sunk(ship, player.friendly_board)
    intended = ". A B C D E F G H \n1 X X X           \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal intended, player.friendly_board.board_string
  end

  def test_check_if_sunk
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [1, 2, 3])
    ship.sunk = true
    assert_equal "S" player.check_if_sunk(ship, player.friendly_board)
  end

  def test_check_if_sunk_negative
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [1, 2, 3])
    assert_equal "H" player.check_if_sunk(ship, player.friendly_board)
  end

  def test_interpret_guess_hit
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [1, 2, 3])
    result = player.interpret_guess(player.friendly_board, ship, ["A", 1])
    intended = ". A B C D E F G H \n1 H               \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal "H", result
    assert_equal intended, player.friendly_board.board_string
  end

  def test_interpret_guess_miss
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [2, 3, 4])
    result = player.interpret_guess(player.friendly_board, ship, ["A", 1])
    intended = ". A B C D E F G H \n1 H               \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal "M", result
    assert_equal intended, player.friendly_board.board_string
  end

  def test_interpret_guess_sunk
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [1, 2, 3])
    ship.coordinates_hash = {"A" => {1 => " ", 2 => "H", 3 => "H"}}
    result = player.interpret_guess(player.friendly_board, ship, ["A", 1])
    intended = ". A B C D E F G H \n1 X X X           \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal "S", result
    assert_equal intended, player.friendly_board.board_string
  end

  def test_make_guess_miss
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [2, 3, 4])
    player.friendly_board.ships << ship
    result = player.make_guess(player.friendly_board, "A1, C4")
    intended = ". A B C D E F G H \n1 H               \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal "M", result
    assert_equal intended, player.friendly_board.board_string
  end

  def test_make_guess_hit
    layer = Player.new(8)
    ship = Ship.new(3, ["A"], [1, 2, 3])
    player.friendly_board.ships << ship
    result = player.make_guess(player.friendly_board, "A1, A2")
    intended = ". A B C D E F G H \n1 H               \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal "H", result
    assert_equal intended, player.friendly_board.board_string

  def test_make_guess_sunk
    player = Player.new(8)
    ship = Ship.new(3, ["A"], [1, 2, 3])
    ship.coordinates_hash = {"A" => {1 => " ", 2 => "H", 3 => "H"}}
    player.friendly_board.ships << ship
    result = player.make_guess(player.friendly_board, "A1, A2")
    intended = ". A B C D E F G H \n1 X X X           \n2                 \n3                 \n4                 \n5                 \n6                 \n7                 \n8                 \n"
    assert_equal "S", result
    assert_equal intended, player.friendly_board.board_string
  end
end
