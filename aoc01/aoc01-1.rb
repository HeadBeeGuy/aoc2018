freq_file = File.open("./fakeinput.txt")
freq = freq_file.read

final_freq = 0
freq_hash = {0 => 1}

freq.each_line do |line|
  parsed_number = line[/[0-9]+/].to_i
  if line[0] == '+'
    final_freq += parsed_number
  elsif line[0] == '-'
    final_freq -= parsed_number
  else
    puts "Something went awry! #{line}"
  end
  if freq_hash[final_freq].nil?
    freq_hash.merge!({ final_freq => 1 })
  else
    puts "I found a duplicate at frequency #{final_freq}"
    freq_hash[final_freq] += 1
  end
end 

puts "Final frequency: #{final_freq}"