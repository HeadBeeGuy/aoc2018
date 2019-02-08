# Advent of Code Day 6 part 1
# I came back and did this one after finishing Day 11. For a long time I
# couldn't figure out how to handle infinite areas until I looked at Forrest
# Smith's post. As usual, I imagine this is dreadfully inefficient, but my
# laptop can run it in 1.2 seconds, so I guess that'll do!

def manhattan_dist(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

file = File.open("input.txt")
point_file = file.read

# 2-dimensional array (as represented by hash) that contains the "game space"
# as it were
grid = Hash.new(".")
# the grid only needs to be as big as its largest coordinate, I think
grid_x_size = 0
grid_y_size = 0

all_points = {}
letters = (1..100).to_a
letter_index = 0

point_file.each_line do |line|
  new_point = line.scan(/[0-9]+/)
  new_x = new_point[0].to_i
  new_y = new_point[1].to_i
  all_points.merge!({ letters[letter_index] => {x: new_x, y: new_y, area: 1}})
  grid[[new_x, new_y]] = letters[letter_index]
  
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
    if grid[[x,y]] == "."
      closest_point = nil
      closest_distance = 10000
      potential_duplicate = false
      all_points.each do |point_name, location|
        distance = manhattan_dist(x, y, location[:x], location[:y])
        if distance < closest_distance
          closest_distance = distance
          closest_point = point_name
          potential_duplicate = false
        elsif distance == closest_distance
          potential_duplicate = true
        end
      end

      # If this spot has a point closer than any others, it increases the area
      # of that point by 1
      unless potential_duplicate
        all_points[closest_point][:area] += 1
      end
    end

  end
end

# Anything on the edges is infinite, according to Forrest Smith's blog post
# about Advent of Code. So run around the edges and remove from consideration
# any points that touch it.

for x in 0..grid_x_size
  if grid[[x,0]] != "."
    all_points.delete( grid[[x,0]] )
  end
  if grid[[x,grid_y_size]] != "."
    all_points.delete( grid[[x,grid_y_size]] )
  end
end

for y in 0..grid_y_size
  if grid[[0,y]] != "."
    all_points.delete( grid[[0,y]] )
  end
  if grid[[grid_x_size,y]] != "."
    all_points.delete( grid[[grid_x_size,y]] )
  end
end

max_area = 0
all_points.values.each do |value|
  if value[:area] > max_area
    max_area = value [:area]
  end
end

puts "The maximum finite area is #{max_area}"
