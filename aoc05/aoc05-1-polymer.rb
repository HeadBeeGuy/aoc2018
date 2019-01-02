# Advent of Code 2018 Day 5 part 1
# this seems relatively simple, but we'll see how it goes!
#

# by definition, two of the same letters with opposite cases will react
def react?(first_char, second_char)
  first_char.swapcase == second_char
end

file = File.open("input.txt")
polymer = file.read

chain = polymer.strip.chars

# Iterate through the array, finding reacting polymers and deleting them. I
# think I could do this in only one traversal if I could look backward, but
# Ruby's handy iterator functions don't seem to let you alter the index the way
# you could in C, for example. We'll see if this leads to cartoonish
# inefficiency with the real data.
no_reactions = false
until no_reactions
  no_reactions = true
  chain.each_index do |index|
    if react?(chain[index], chain[index + 1])
      chain.delete_at(index + 1)
      chain.delete_at(index)
      no_reactions = false
    end
  end
end

puts "The final chain is #{chain.size} characters long."
