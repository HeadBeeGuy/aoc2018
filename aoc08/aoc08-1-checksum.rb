# Advent of Code Day 8 part 1
# Sweet grover did this one throw me for a loop! I think I had several mistakes
# in the algorithms I was using in previous attempts. A lot of them worked on
# the test data but fell apart with the actual data with infinite recursion or
# inaccurate sums. But I stuck with it!

# When passed an array, find the total size, in number of array entries, of all
# its children. This is so we can identify the metadata nodes that occur after
# it and sum them all up.
# This always passes in the full tail of the array past this starting point,
# which is probably quite inefficient. Modern hardware saves me once again!
def size_of_children(arr)
  children_count = arr[0]
  metadata_count = arr[1]

  if children_count == 0
    # No further recursion necessary. Metadata entries simply follow the second
    # entry.
    $metadata_total += arr[2..(metadata_count+1)].sum
    # The size is the two information entries in the beginning, plus however
    # many metadata nodes we have.
    return (2 + metadata_count)
  elsif children_count >= 1
    # We've got one or more children, but we don't know how big they are. Find
    # their size, so that we know how many entries to skip to get to this
    # node's metadata.
    total_children_size = 0

    # we can only know where the next child starts by knowing how big its
    # previous siblings were
    children_count.times do
      total_children_size += size_of_children(arr[2+total_children_size..-1])
    end

    # find metadata total, assuming it's greater than zero
    metadata_nodes = []
    $metadata_total += arr[(2 + total_children_size)..(1 + total_children_size + metadata_count)].sum

    return (2 + total_children_size + metadata_count)
  end
end

$metadata_total = 0

file = File.open("input.txt")
tree_file = file.read
root_list = tree_file.strip.split
root_list.map!(&:to_i) # they're interpreted as strings by default

size_of_children(root_list)

puts "Final metadata total: #{$metadata_total}"


