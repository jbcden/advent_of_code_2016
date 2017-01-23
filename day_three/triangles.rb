triangles = []
file = IO.readlines('./triangles')
while !file.empty?
  tmp = []
  3.times do
    line = file.pop.chomp.split
    tmp << line
  end

  r1, r2, r3 = tmp

  r1.zip(r2, r3).each do |triangle|
    a, b, c = triangle
    if (a.to_i + b.to_i) > c.to_i &&  (b.to_i + c.to_i) > a.to_i &&  (c.to_i + a.to_i) > b.to_i
      triangles.push(triangle)
    end
  end
end

p triangles.size











# IO.readlines('./triangles').each do |l|
#   line = l.chomp
#   a, b, c = line.split
#   (a.to_i + b.to_i) > c.to_i &&  (b.to_i + c.to_i) > a.to_i &&  (c.to_i + a.to_i) > b.to_i
# end
