# Advent of Code 2018 Day 5 part 2
# Updating my day 2 solution with the new version of day 1's. It's still
# inefficiently running through the day 1 solution 26 times, but it's faster
# than it used to be - 4.8 seconds on my laptop. I can probably improve on
# this, but I'll see if I have the time!


file = File.open("input.txt")
polymer = file.read

chain = polymer.strip.chars
results = {}

('a'..'z').each do |letter|
  modified_chain = chain - [letter, letter.upcase]
  current_position = 0
  until modified_chain[current_position + 1].nil?
    if modified_chain[current_position] == modified_chain[current_position + 1].swapcase
     modified_chain.delete_at(current_position)
      modified_chain.delete_at(current_position)
      current_position -= 1
    else
      current_position += 1
    end
  end
  results.merge!({ letter => modified_chain.size })

  print "#{letter}"
end
print "\n"

puts "The minimum chain length was #{results.values.min} and the maximum was #{results.values.max}."
