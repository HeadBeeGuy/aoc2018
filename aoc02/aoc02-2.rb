file = File.open("input.txt")
id_list = file.read

# turn the file into a big array, removing newlines
# this would likely be unfeasible in an enormous file
box_ids = []
id_list.each_line do |line|
  box_ids << line.strip
end

near_matches = []
found_match = false
box_ids.each do |id|
  # doing this outside the loop since it'll happen n times
  split_id = id.chars

  # iterate over the entire list twice - is this exponential growth?
  box_ids.each do |second_id|
    # extremely clever solution found here:
    # https://stackoverflow.com/a/39713422
    character_difference = split_id.zip(second_id.chars)
      .select{ |a,b| a != b }.count
    if character_difference == 1 && !found_match
      near_matches << id << second_id
      found_match = true # otherwise it finds it twice
    end
  end

end

puts "The following ids should only differ by one letter: #{near_matches.inspect}"

#invert the previous answer, finding only strings in common
common_characters = ""
near_matches[0].chars.zip(near_matches[1].chars).select do |a,b|
  if a == b
    common_characters << a
  end
end

puts "They should have the following characters in common: #{common_characters}"
