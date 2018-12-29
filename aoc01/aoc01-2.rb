freq_file = File.open("./input")
freq = freq_file.read

# first, build an array out of the operations
operations = []
freq.each_line do |line|
  operations << line.to_i
end

# next, build a hash table out of the results of applying these operations
freq_hash = {0 => 1}
found_duplicate = false
result_freq = 0

while found_duplicate == false
  operations.each do |item|
    result_freq += item 
    if freq_hash[result_freq].nil?
      freq_hash.merge!({result_freq => 1})
      # puts "I found a new frequency result: #{result_freq}"
    else
      unless found_duplicate == true 
        puts "I found a duplicate! #{result_freq}"
      end
      freq_hash[result_freq] += 1
      found_duplicate = true
    end
  end
end
