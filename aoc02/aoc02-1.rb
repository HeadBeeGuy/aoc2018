# can these be combined? I always look up and then forget
# the particulars of Ruby file manipulation
file = File.open("input.txt")
id_list = file.read

# turn the file into a big array, removing newlines
# this would likely be unfeasible in an enormous file
box_ids = []
id_list.each_line do |line|
  box_ids << line.strip
end

two_repeated = 0
three_repeated = 0
found_double = false
found_triple = false

box_ids.each do |id|
  # the count function feels like cheating
  # I would probably need to do much more work in a lower-level language!
  id.each_char do |char|
    if id.count(char) == 2 && found_double == false
      two_repeated += 1
      found_double = true # subsequent doubles aren't counted
    elsif id.count(char) == 3 && found_triple == false
      three_repeated += 1
      found_triple = true
    end
  end

  # we've finished analyzing all of the characters in the string
  # reset the booleans so we can look at the next string with fresh eyes
  found_double = false
  found_triple = false
end

puts "I think I found #{two_repeated} doubles and #{three_repeated} triples."
puts "This gives a product of #{two_repeated * three_repeated}"

