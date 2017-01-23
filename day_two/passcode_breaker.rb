class PasscodeBreaker
  attr_reader :position

  BEGINING_POSITION = 5

  def initialize(codes, row_size)
    @codes = codes
    @position = BEGINING_POSITION
    @row_size = row_size
  end

  def move(direction)
    case direction
    when 'U'
      new_position = @codes.index(position) - @row_size
      @position = calculate_vertical_position(new_position, :up)
    when 'D'
      new_position = @codes.index(position) + @row_size
      @position = calculate_vertical_position(new_position, :down)
    when 'L'
      new_position = @codes.index(position) - 1
      calculate_horizontal_position(new_position, :left)
    when 'R'
      new_position = @codes.index(position) + 1
      calculate_horizontal_position(new_position, :right)
    end
  end

  private

  def calculate_vertical_position(index, dir)
    @position = if vertical_position_invalid?(index, dir)
                  position
                else
                  @codes[index]
                end
  end

  def vertical_position_invalid?(index, dir)
    (dir == :down ? index >= upper_boundary : index < lower_boundary) || @codes[index].nil?
  end

  def calculate_horizontal_position(new_index, dir)
    @codes.each_slice(@row_size) do |row|
      row = row.compact
      boundary = dir == :left ? 0 : row.size - 1
      index = row.index(position)
      next if horizontal_position_invalid?(index, boundary)

      @position = @codes[new_index]
    end
  end

  def horizontal_position_invalid?(index, boundary)
    index.nil? || index == boundary
  end

  def lower_boundary
    0
  end

  def upper_boundary
    @codes.length
  end
end

# CD8D4
codes2 = [
  nil, nil, 1, nil, nil,
  nil,   2, 3,   4, nil,
    5,   6, 7,   8,   9,
  nil, 'A', 'B', 'C', nil,
  nil, nil, 'D', nil, nil
]

# 98575
codes = (1..9).to_a
breaker = PasscodeBreaker.new(codes2, 5)

IO.readlines('./part1').each do |l|
  line = l.chomp

  line.split('').each do |direction|
    breaker.move(direction)
  end
  print breaker.position
end
puts
