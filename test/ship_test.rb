require 'minitest/autorun'
require './lib/ship'

class ShipTest < Minitest::Test
  def test_are_they_linear
    ship = Ship.new(3, ["A", "B", "C"], [1])
    assert_equal true, ship.are_they_linear?(["A", "B", "C"], [1])
  end

  def test_theyre_not_linear
    ship = Ship.new(3, ["A", "B", "C"], [1, 2])
    assert_equal false, ship.are_they_linear?(["A", "B", "C"], [1, 2])
  end

  def test_consecutive
    ship = Ship.new(3, ["A", "B", "C"], [1])
    assert_equal true, ship.consecutive?(["A", "B", "C"])
  end

  def test_not_consecutive_alpha
    ship = Ship.new(3, ["A", "D", "E"], [2])
    assert_equal false, ship.consecutive?(["A", "D", "E"])
  end

  def test_not_consecutive_numeric
    ship = Ship.new(3, ["A"], [1, 3, 6])
    assert_equal false, ship.consecutive?([1, 3, 6])
  end

  def test_check_if_legal
    ship = Ship.new(3, ["B"], [2, 3, 4])
    assert_equal true, ship.check_if_legal(["B"], [2, 3, 4])
  end

  def test_not_legal_size
    ship = Ship.new(5, ["C"], [3, 4, 5])
    assert_equal false, ship.check_if_legal(["C"], [3, 4, 5])
  end

  def test_make_coordinates_hash
    ship = Ship.new(3, ["C"], [3, 4, 5])
    ship.make_coordinates_hash(["C"], [3, 4, 5])
    expected = {"C" => {3 => " ", 4 => " ", 5 => " "}}
    assert_equal expected, ship.coordinates_hash
  end

  def test_make_illegal_coordinates_hash
    ship = Ship.new(3, ["C"], [1, 4, 7])
    assert ship.coordinates_hash.empty?
  end

  def test_if_sunk_false
    ship = Ship.new(3, ["C"], [3, 4, 5])
    assert_equal false, ship.check_if_sunk
    assert_equal false, ship.sunk
  end

  def test_if_sunk_true
    ship = Ship.new(3, ["C"], [3, 4, 5])
    ship.coordinates_hash = {"C" => {3 => "H", 4 => "H", 5 => "H"}}
    assert_equal true, ship.check_if_sunk
    assert_equal true, ship.sunk
  end
end
