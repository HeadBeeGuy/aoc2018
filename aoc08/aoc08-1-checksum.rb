# Advent of Code Day 8 part 1

# nothing but extremely basic, exploratory code at the moment - just using this commit to sync it between my PC and laptop.
file = File.open("sample_input.txt")
tree_file = file.read
root_list = tree_file.strip.split
root_list.map!(&:to_i) # they're interpreted as strings by default

metadata_total = 0

child_count = root_list[0]
metadata_count = root_list[1]
puts "Detecting #{child_count} children and #{metadata_count} metadata entries."

puts "Now the array is #{root_list}"