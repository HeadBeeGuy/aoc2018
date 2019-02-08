# Advent of Code Day 6 part 2
# This one was a lot easier than part 1! I could just trim out a lot of part
# 1's solution and add a total tracker. The variable names are kind of a mess,
# but so it goes. It runs in about a second on my laptop.

def manhattan_dist(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

file = File.open("input.txt")
point_file = file.read

# the grid only needs to be as big as its largest coordinate, I think
grid_x_size = 0
grid_y_size = 0
final_total = 0

all_points = {}
letters = (1..100).to_a
letter_index = 0

point_file.each_line do |line|
  new_point = line.scan(/[0-9]+/)
  new_x = new_point[0].to_i
  new_y = new_point[1].to_i
  all_points.merge!({ letters[letter_index] => {x: new_x, y: new_y}})
  
  if new_x > grid_x_size
    grid_x_size = new_x
  end
  if new_y > grid_y_size
    grid_y_size = new_y
  end

  letter_index += 1
end

for y in 0..grid_y_size
  for x in 0..grid_x_size
    total_distance = 0
    all_points.each do |point_name, location|
      total_distance += manhattan_dist(x, y, location[:x], location[:y])
    end

    if total_distance < 10000
      final_total += 1
    end

  end
end

puts "Points which have a total distance to all points less than 10000: #{final_total}"
