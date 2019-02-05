# Advent of Code Day 11 part 2
# I was reading Forrest Smith's post on Hacker News about how he used Advent of
# Code to practice Rust. I saw in his solutions that he found out about the
# Summed-area table and thought it was neat. This is my implementation, but of
# course, not my idea! Whoever comes up with stuff like this is far more clever
# than I am!

$serial_num = 7511 # my input

# find the power level of a given cell
def power_level(x, y)
  ((((x + 10) * y ) + $serial_num) * (x + 10)).digits[2] - 5
end

fuel_cells = Hash.new(0)

# The fancy new tool that I must emphasize I didn't think of or know about!
sat = Hash.new(0)

max_power = 0
max_power_location = []

# Compute our fuel cell array and generate the summed-area table
for x in 1..300
  for y in 1..300
    my_power = power_level(x,y)
    fuel_cells[[x,y]] = my_power
    sat[[x,y]] = my_power + sat[[x-1, y]] + sat[[x, y-1]] - sat[[x-1, y-1]]
  end
end

# Now traverse the summed-area table, essentially drawing giant squares and
# using the property that the sum of all items in the square can be calculated
# by simple addition and substraction performed near its "corners." 

for square_size in 1..299
  for x in 1..(300 - square_size)
    for y in 1..(300 - square_size)
      # bottom corner coordinates
      bcx = x + square_size
      bcy = y + square_size
      sum = sat[[bcx, bcy]] + sat[[x-1,y-1]] - sat[[bcx, y-1]] - sat[[x-1,bcy]]

      if sum > max_power
        max_power = sum
        max_power_location = [x, y, square_size + 1]
      end
    end
  end
end


puts "The max power is #{max_power}, which can be found in cell #{max_power_location.inspect}"
