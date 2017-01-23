Point = Struct.new(:x, :y)
$history = []

directions = "L1, R3, R1, L5, L2, L5, R4, L2, R2, R2, L2, R1, L5, R3, L4, L1, L2, R3, R5, L2, R5, L1, R2, L5, R4, R2, R2, L1, L1, R1, L3, L1, R1, L3, R5, R3, R3, L4, R4, L2, L4, R1, R1, L193, R2, L1, R54, R1, L1, R71, L4, R3, R191, R3, R2, L4, R3, R2, L2, L4, L5, R4, R1, L2, L2, L3, L2, L1, R4, R1, R5, R3, L5, R3, R4, L2, R3, L1, L3, L3, L5, L1, L3, L3, L1, R3, L3, L2, R1, L3, L1, R5, R4, R3, R2, R3, L1, L2, R4, L3, R1, L1, L1, R5, R2, R4, R5, L1, L1, R1, L2, L4, R3, L1, L3, R5, R4, R3, R3, L2, R2, L1, R4, R2, L3, L4, L2, R2, R2, L4, R3, R5, L2, R2, R4, R5, L2, L3, L2, R5, L4, L2, R3, L5, R2, L1, R1, R3, R3, L5, L2, L2, R5"

def determine_direction(current, prompt)
  cardinal = [:north, :east, :south, :west]

  if prompt == "L"
    cardinal[(cardinal.index(current) - 1) % 4]
  else
    cardinal[(cardinal.index(current) + 1) % 4]
  end
end

def move(current, amount, direction)
  if [:north, :south].include?(direction)
    amount.times do
      current.y += (direction == :north ? 1 : -1)
      if $history.include?(current)
        return current, :end
      end

      $history.push(current.dup)
    end
  else
    amount.times do
      current.x += (direction == :east ? 1 : -1)
      if $history.include?(current)
        return current, :end
      end

      $history.push(current.dup)
    end
  end
  current
end

def read_directions(directions)
  p = Point.new(0, 0)
  d = :north
  directions.split(", ").each do |dir|
    _, prompt, amount = dir.partition(/L|R/)
    d = determine_direction(d, prompt)
    p, flag = move(p, amount.to_i, d)
    break if flag == :end
  end

  p.x.abs + p.y.abs
end

p read_directions(directions)
