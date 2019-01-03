# Advent of Code 2018 Day 5 part 2
# Just changing my answer to part 1 a little. This is really gonna emphasize
# how inefficient my multiple-traversal solution was. But hey, that's what
# hardware is for! We can implement more economical solutions once all the
# children have their presents!

# by definition, two of the same letters with opposite cases will react
def react?(first_char, second_char)
  first_char.swapcase == second_char
end

file = File.open("input.txt")
polymer = file.read

chain = polymer.strip.chars

# Just do the previous solution 26 times, once for each letter of the alphabet.
# Logically simple if completely inelegant and wasteful!

('a'..'z').each do |letter|
  # I'm amazed at how easy it is to do this in Ruby
  modified_chain = chain - [letter, letter.upcase]

  no_reactions = false
  until no_reactions
    no_reactions = true
    modified_chain.each_index do |index|
      if react?(modified_chain[index], modified_chain[index + 1])
        modified_chain.delete_at(index + 1)
        modified_chain.delete_at(index)
        no_reactions = false
      end
    end
  end
  print "#{letter}: #{modified_chain.size} || "
end
print "\n"
