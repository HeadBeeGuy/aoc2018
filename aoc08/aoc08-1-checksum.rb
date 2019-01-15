# Advent of Code Day 8 part 1

$metadata_total = 0

# this one passes the array around
# and it works on sample data!
# def size_of_children(base_array)
#   # puts "Entering size_of_children function. The array looks like: #{base_array.inspect}"
#   # the first two entries will always exist
#   children_count = base_array[0]
#   metadata_count = base_array[1]
#   if children_count == 0
#     # we've bottomed out
#     metadata_entries = base_array[2..(metadata_count + 1)]
#     # puts "Bottomed out. The following entries are metadata: #{metadata_entries.inspect}"
#     # puts "You should add this sum to the final: #{metadata_entries.sum}"
#     $metadata_total += metadata_entries.sum
#     # so how big is this child?
#     ( 2 + metadata_count )
#   elsif children_count >= 1
#     # We've got at least one child, but we don't know how big it is. Find how
#     # big the first child is, then keep going through the remaining children,
#     # finding their sizes in turn. And in doing so, we'll find their metadata
#     # sums as well.
#     # puts "I detect this many children: #{children_count}"
#     current_child_index = 2
#     children_count.times do
#       # puts "Entering the recursive bit. current_child_index is presently: #{current_child_index}"
#       current_child_index += size_of_children(base_array[(current_child_index)..-1])
#     end
#     # Once we're done iterating through the children, we know where this node's
#     # metadata starts
#     if metadata_count == 1
#       metadata_entries = [ base_array[current_child_index] ]
#     else
#       # this code breaks and goes one entry off if metadata_count is 1
#       metadata_entries = base_array[(current_child_index + 1)..(current_child_index+metadata_count)]
#     end
#     $metadata_total += metadata_entries.sum
#     current_child_index
#   end
# end

# I rewrote the previous function to not alter the original array at all, just
# play around with where it starts. But in either case, OS X will toss up an
# error "stack level too deep". Maybe it just doesn't like how much recursion
# is going on? I'll have to take this home and see if it runs on my desktop.
def size_of_children(big_array, start_index)
  # the first two entries will always exist
  children_count = big_array[start_index]
  metadata_count = big_array[start_index + 1]
  # puts "I detect #{children_count} children and #{metadata_count} metadata entries."
  if children_count == 0
    # we've bottomed out
    metadata_entries = big_array[(start_index + 2)..(start_index + metadata_count + 1)]
    # puts "Bottomed out. The following entries are metadata: #{metadata_entries.inspect}"
    # puts "You should add this sum to the final: #{metadata_entries.sum}"
    $metadata_total += metadata_entries.sum
    # so how big is this child?
    ( 2 + metadata_count )
  elsif children_count >= 1
    # We've got at least one child, but we don't know how big it is. Find how
    # big the first child is, then keep going through the remaining children,
    # finding their sizes in turn. And in doing so, we'll find their metadata
    # sums as well.
    current_child_index = 2
    children_count.times do
      # puts "Entering the recursive bit. current_child_index is presently: #{current_child_index}"
      current_child_index += size_of_children(big_array, (start_index + current_child_index))
    end
    # Once we're done iterating through the children, we know where this node's
    # metadata starts
    if metadata_count == 1
      metadata_entries = [ big_array[start_index + current_child_index] ]
    else
      # this code breaks and goes one entry off if metadata_count is 1
      metadata_entries = big_array[(start_index + current_child_index + 1)..(start_index + current_child_index+metadata_count)]
    end
    # puts "We've come back out to a parent node's metadata entries. Here they are: #{metadata_entries}"
    $metadata_total += metadata_entries.sum
    current_child_index
  end
end

file = File.open("sample_input.txt")
tree_file = file.read
root_list = tree_file.strip.split
root_list.map!(&:to_i) # they're interpreted as strings by default

size_of_children(root_list, 0)

puts "Total calculated metadata: #{$metadata_total}"
