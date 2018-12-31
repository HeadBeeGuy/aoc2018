# Advent of Code 2018 Problem 3 part 1

# this is just a primitive display function
def draw_array_chunk(display_hash, x_start, x_end, y_start, y_end)
  for y in y_start..y_end
    for x in x_start..x_end
      if display_hash[[x,y]].nil?
        print "."
      elsif display_hash[[x,y]] == true
        print "X"
      else
        print display_hash[[x,y]]
      end
    end
    puts ""
  end
end

file = File.open("input.txt")
claim_list = file.read

# the size of the cloth is defined ahead of time
cloth_size = 1000

# I'm going to use this way of representing 2-dimensional arrays in Ruby that I
# found on StackOverflow: https://stackoverflow.com/a/1721693
cloth = {}
multiple_claims = {}

multiple_claim_count = 0

#ideally we can do all of this with a single traversal of the claim list!
claim_list.each_line do |line|
  # at least at this stage, we can ignore the claim number
  # all we need is its position and how big it is

  # this splits up the line into a big array, so we don't have to parse it 4
  # times. the array is messy but since the data is well-formatted, it should
  # suffice
  this_line = line.split(/(\s|#|,|\:|x)/)
  x_index = this_line[6].to_i
  y_index = this_line[8].to_i
  x_size = this_line[12].to_i
  y_size = this_line[14].to_i

  # stake out the actual claim
  # there's something about just adding the size to the index that makes claims
  # one square too big. I'm not quite sure why. I think I'm having a "missing a
  # forest for the trees" moment
  for y in y_index..(y_index + y_size - 1)
    for x in x_index..(x_index + x_size - 1)
      if cloth[[x,y]].nil?
        cloth[[x,y]] = 1
      else
        # there was already a claim here
        cloth[[x,y]] += 1
        # was this the first time this happened?
        if multiple_claims[[x,y]].nil?
          multiple_claims[[x,y]] = true
          multiple_claim_count += 1
        end
      end
    end
  end
end

# find a random section of the cloth to see if claiming works correctly
x_chunk_start = Random.rand(1..(cloth_size - 70))
x_chunk_end = x_chunk_start + 70
y_chunk_start = Random.rand(1..(cloth_size - 25))
y_chunk_end = y_chunk_start + 25

puts "Here's a section of the cloth with claims:"
draw_array_chunk(cloth, x_chunk_start, x_chunk_end, y_chunk_start, y_chunk_end)
puts "And here's where the claims should overlap:"
draw_array_chunk(multiple_claims, x_chunk_start, x_chunk_end, y_chunk_start, y_chunk_end)

puts "Total squares with more than one claim: #{multiple_claim_count}"

