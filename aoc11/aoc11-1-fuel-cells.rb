# Advent of Code Day 11 part 1
# As usual, perhaps a naive implementation, but simple enough!
# It takes about 2.6 seconds on my laptop, which probably won't cut the mustard
# for part 2.

$serial_num = 7511 # my input

# find the power level of a given cell
def power_level(x, y)
  ((((x + 10) * y ) + $serial_num) * (x + 10)).digits[2] - 5
end

# I'll represent 2-dimensional arrays as a hash map, like I did on another
# day's answer. Indices will start at 1 since it's less confusing.

# The power grid, as it were. Value is the power level at any given location.
fuel_cells = Hash.new(0)

# The total power available at a given cell, assuming it is the top left cell
# of a 3x3 grid. Our goal is to find the cell with the maximum value.
available_power = Hash.new(0)

max_power = 0
max_power_location = []

for x in 1..300
  for y in 1..300
    # how much power do we have here?
    my_power = power_level(x,y)
    fuel_cells[[x,y]] = my_power

    # Fan backward, essentially - add this cell's power level to the total
    # power available to all other cells that can claim it. This should be a
    # 3x3 grid with this cell in the bottom right.
    for back_x in (x-2)..x
      for back_y in (y-2)..y
        # the grid is the grid! no going outside!
        if back_x > 0 && back_y > 0
          available_power[[back_x, back_y]] += my_power

          # did we find a new max?
          if available_power[[back_x, back_y]] > max_power
            max_power = available_power[[back_x, back_y]]
            max_power_location = [ back_x, back_y ]
          end
        end

      end
    end
  end
end

puts "The max power is #{max_power}, which can be found in cell #{max_power_location.inspect}"
