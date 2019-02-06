# Advent of Code Day 10 part 1
#

class Point

  def initialize(x_position, y_position, x_velocity, y_velocity)
    @x_position = x_position
    @y_position = y_position
    @x_velocity = x_velocity
    @y_velocity = y_velocity
  end

  # calling this will update the point's position and return the new position
  def current_position
    @x_position += x_velocity
    @y_position += y_velocity
    [@x_position, @y_position]
  end
end


file = File.open("sample_input.txt")
initial_point_info = file.read

all_points = []

initial_point_info.each_line do |line|
  # match all digits or a minus sign
  point_info = line.scan(/[\d|-]+/)

  # this produces an array with 4 elements
  new_point = Point.new(point_info[0],
                        point_info[1],
                        point_info[2],
                        point_info[3])

  all_points << new_point
end

puts all_points.inspect
