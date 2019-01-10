# Advent of Code Day 7 part 1
# This is probably another naive implementation of this idea, and I'm sure
# there's a more elegant way of going about things. step_tree is a big hash
# that sort of works likes a database key on the letter.

no_prereqs = []
potential_steps = []
step_tree = {}
final_order = ""

("A".."Z").each do |letter|
  step_tree.merge!( { letter => { prereqs: [], children: [] } } )
  no_prereqs << letter
end

file = File.open("input.txt")
instruction_list = file.read

instruction_list.each_line do |line|
  # in 0-indexing, the first step comes at index 5 and the second comes at
  # index 36
  # Thus, item 1 is the parent, and item 2 is the child in our tree structure
  parent = line[5]
  child = line[36]
  
  # Add in the prerequisites - there could be several specified across several
  # steps
  step_tree[child][:prereqs] << parent

  # The example framed things in terms of a top-down traversal of the chart, so
  # to facilitate that, I'll store child nodes as well. Once we complete a
  # step, we can move on to its children
  step_tree[parent][:children] << child

  # While we're here, eliminate the child node from the list of nodes that
  # don't have prerequisites.
  no_prereqs -= [child]
end

potential_steps += no_prereqs

until potential_steps.empty?
  # potential_steps contains only nodes whose requirements are met, so take the
  # first one alphabetically
  potential_steps.sort!
  next_step = potential_steps[0]

  final_order << next_step
  potential_steps -= [ next_step ]
  step_tree[next_step][:children].each do |new_step|
    # Add the children in to the potential steps, but only if all of their
    # prerequisites have been satisfied.
    prereqs_met = true
    step_tree[new_step][:prereqs].each do |prereq|
      if !final_order.include?(prereq)
        prereqs_met = false
      end
    end

    if prereqs_met
      potential_steps << new_step
    end
  end
end

puts "Here's the final order of completion: #{final_order}"
