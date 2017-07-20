class Ship
  attr_accessor :coordinates_hash, :uninitialized, :sunk
  def initialize(size, column_values, row_values)
    @size = size
    @coordinates_hash = {}
    make_coordinates_hash(column_values, row_values)
    @uninitialized = {}
    @sunk = false
  end

  def are_they_linear?(column_values, row_values)
    if column_values.size == 1 || row_values.size == 1
      true
    else
      false
    end
  end

  def consecutive?(values)
    consecutive = true
    if values.size > 1
      for i in 1..(values.size - 1)
        if values[i].ord != values[i - 1].ord + 1
          consecutive = false
        end
      end
    end
    consecutive
  end

  def check_if_legal(column_values, row_values)
    legal = false
    if are_they_linear?(column_values, row_values)
      if consecutive?(column_values) && consecutive?(row_values)
        if column_values.size == @size || row_values.size == @size
          legal = true
        end
      end
    end
    legal
  end

  def make_coordinates_hash(column_values, row_values)
    cv = column_values.uniq
    rv = row_values.uniq
    if check_if_legal(rv, cv)
      cv.each do |column_value|
        @coordinates_hash.store(column_value, {})
        rv.each do |row_value|
          @coordinates_hash[column_value].store(row_value, " ")
        end
      end
    end
  end

  def check_if_sunk
    @sunk = true
    @coordinates_hash.keys.each do |column|
      @coordinates_hash[column].keys.each do |row|
        if @coordinates_hash[column][row] == " "
          @sunk = false
        end
      end
    end
    return @sunk
  end
end
