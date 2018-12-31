# Advent of Code 2018 Day 3 part 2

file = File.open("input.txt")
claim_list = file.read

# the size of the cloth is defined ahead of time
cloth_size = 1000

# I'm going to use this way of representing 2-dimensional arrays in Ruby that I
# found on StackOverflow: https://stackoverflow.com/a/1721693
cloth = {}

# In order to still be able to do this in one traversal, this will be an array
# of what are considered "clean claims" - claims that don't intersect with
# anything else. If a new claim conflicts with an old one, it removes itself
# from consideration and pulls the old claim out of this array.
# If all goes well, this will only have one item!
clean_claims = []


claim_list.each_line do |line|
  this_line = line.split(/(\s|#|,|\:|x)/)
  claim_number = this_line[2].to_i
  x_index = this_line[6].to_i
  y_index = this_line[8].to_i
  x_size = this_line[12].to_i
  y_size = this_line[14].to_i

  # for each new claim, we need to see if any of it overlaps with previous
  # claims, and if they do, which claims they were
  clean_claim = true

  # stake out the actual claim
  # this time around, each spot is an array with the ids of all claims that
  # have been made on this spot
  for y in y_index..(y_index + y_size - 1)
    for x in x_index..(x_index + x_size - 1)
      if cloth[[x,y]].nil?
        cloth[[x,y]] = [claim_number]
      else
        # there was already a claim here
        clean_claim = false
        # This is inefficient - large claim overlaps will make this run many
        # times. But given the current size of the problem set, it doesn't seem
        # to increase run time on my system very much.
        cloth[[x,y]].each do |previous_claim_id|
          # this shouldn't cause any issues even if it wasn't present
          clean_claims.delete(previous_claim_id)
        end
        cloth[[x,y]] << claim_number
      end
    end
  end

  # if we've made it this far with no overlapping claims, it's a potential
  # candidate for the one clean claim
  if clean_claim
    clean_claims << claim_number
  end
end

puts "Remaining claims that didn't interfere with anything: #{clean_claims.inspect}"

