# Advent of Code 2018 Day 5 part 1
# I was really unsatisfied with my previous implementation, so I came back and
# wrote it again. It runs much, much faster - .3 seconds on my laptop.

file = File.open("input.txt")
polymer = file.read

chain = polymer.strip.chars
current_position = 0

until chain[current_position + 1].nil?
  if chain[current_position] == chain[current_position + 1].swapcase
    # This is a weird way to delete the two items, but doing it another way
    # causes the answer to be incorrect - in my case, two off. I'm not sure
    # why! There must be an edge case that I'm not thinking of.
    chain.delete_at(current_position)
    chain.delete_at(current_position)
    current_position -= 1
  else
    current_position += 1
  end
end

puts "The final chain is #{chain.size} characters long."
