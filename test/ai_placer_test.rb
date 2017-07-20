require 'minitest/autorun'
require './lib/ai_placer'

class AiPlacerTest < Minitest::Test
  def test_initialize_big_ships
    placer = AiPlacer.new(12, Player.new(12))
    assert_equal [1, 1, 1, 1], placer.ships
  end

  def test_find_ship_vertical
    placer = AiPlacer.new(12, Player.new(12))
    placer.placed_ships << Ship.new(4, ["A"], [4, 5, 6, 7])
    spaces = placer.find_ship_vertical("A", 1, 12, placer.placed_ships)
    assert_equal 2, spaces
  end

  def test_find_ship_vertical_no_ship
    placer = AiPlacer.new(12, Player.new(12))
    spaces = placer.find_ship_vertical("A", 1, 12, placer.placed_ships)
    assert_equal 11, spaces
  end

  def test_find_ship_horizontal
    placer = AiPlacer.new(12, Player.new(12))
    placer.placed_ships << Ship.new(4, ["A", "B", "C", "D"], [1])
    spaces = placer.find_ship_horizontal("F", 1, "A".ord, placer.placed_ships)
    assert_equal 1, spaces
  end

  def test_find_ship_horizontal_negative
    placer = AiPlacer.new(12, Player.new(12))
    spaces = placer.find_ship_horizontal("F", 1, "A".ord, placer.placed_ships)
    assert_equal 5, spaces
  end

  def test_check_available_spaces
    placer = AiPlacer.new(12, Player.new(12))
    placer.placed_ships << Ship.new(4, ["A", "B", "C", "D"], [1])
    placer.placed_ships << Ship.new(3, ["A"], [2, 3, 4])
    up_down = placer.check_available_spaces("D", 4, "vertical")
    right_left = placer.check_available_spaces("D", 4, "horizontal")
    assert_equal [2, 8], up_down
    assert_equal [8, 2], right_left
  end

  def test_adjust_for_wiggle_room
    placer = AiPlacer.new(12, Player.new(12))
    result_array = placer.adjust_for_wiggle_room([4, 4], 5)
    ship_length = result_array[0] + result_array[1]
    assert_equal 5, ship_length
  end

  def test_pick_spaces
    placer = AiPlacer.new(12, Player.new(12))
    spaces_and_orientation = placer.pick_spaces([2, 1], [4, 3], 5)
    assert_equal 5, spaces_and_orientation[0].sum
    assert_equal "H", spaces_and_orientation[1]
  end

  def test_gather_vertical_values
    placer = AiPlacer.new(12, Player.new(12))
    row_values = placer.gather_vertical_values(4, 3, 0)
    assert_equal [1, 2, 3, 4], row_values
  end

  def test_gather_horizontal_values
    placer = AiPlacer.new(12, Player.new(12))
    column_values = placer.gather_horizontal_values("G", 3, 1)
    assert_equal ["F", "G", "H", "I", "J"], column_values
  end

  def test_gather_space_values_vertical
    placer = AiPlacer.new(12, Player.new(12))
    values = placer.gather_space_values("A", 4, 2, 2, "V")
    assert_equal [["A"], [2, 3, 4, 5, 6]], values
  end

  def test_gather_space_values_horizontal
    placer = AiPlacer.new(12, Player.new(12))
    values = placer.gather_space_values("D", 4, 1, 3, "H")
    assert_equal [["A", "B", "C", "D", "E"], [4]], values
  end

  def test_make_new_ship
    placer = AiPlacer.new(12, Player.new(12))
    placer.make_new_ship(5, ["A", "B", "C", "D", "E"], [4])
    assert_instance_of Ship, placer.placed_ships
  end

  def test_place_ships
    placer = AiPlacer.new(12, Player.new(12))
    placer.place_ships
    assert_equal 4, placer.placed_ships.size
  end
end
