# Advent of Code Day 8 part 2
# The same code from part 1, slightly modified to return more.

# We have to return a more complex result than in part 1 in order to add the
# value of each node.
def size_of_children(arr)
  children_count = arr[0]
  metadata_count = arr[1]

  if children_count == 0
    # the value is simply the sum of child nodes
    value = arr[2..(metadata_count+1)].sum
    $metadata_total += value
    return {size: (2 + metadata_count), value: value}
  elsif children_count >= 1
    total_children_size = 0

    child_nodes_values = [ nil ] # we need a dummy item at index 0

    children_count.times do |index|
      kiddo_report = size_of_children(arr[2+total_children_size..-1])
      total_children_size += kiddo_report[:size]
      child_nodes_values << kiddo_report[:value]
    end

    metadata_nodes = arr[(2 + total_children_size)..(1 + total_children_size + metadata_count)]
    $metadata_total += metadata_nodes.sum

    # Value is more complicated when the node has child nodes. Value is the sum
    # of the values of child nodes referred to, but we have to be careful since
    # arrays are 0-indexed and references to child nodes are 1-indexed. If the
    # child node doesn't actually exist, the value is 0.
    total_value = 0
    metadata_nodes.each do |node|
      total_value += child_nodes_values.fetch(node, 0)
    end

    return {size: (2 + total_children_size + metadata_count), value: total_value}
  end
end

$metadata_total = 0

file = File.open("input.txt")
tree_file = file.read
root_list = tree_file.strip.split
root_list.map!(&:to_i) # they're interpreted as strings by default

puts "Total node value: #{size_of_children(root_list)[:value]}"

puts "Final metadata total: #{$metadata_total}"


