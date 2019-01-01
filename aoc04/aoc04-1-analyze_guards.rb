# Advent of Code Day 4 Part 1
# This takes the nicely sorted and formatted input from the "sort input" script
# and then analyzes it to find which guard sleeps the most, and the time at
# which they're most likely to sleep. I could have probably done this in one
# file and with better separation of concerns if I were a better programmer!

class Guard
  attr_accessor :id, :sleep_times, :wake_times, :total_time_asleep

  def initialize(id)
    @id = id
    @sleep_times = []
    @wake_times = []
    @total_time_asleep = 0
  end

  # Calcuate the total time this guard was asleep. Fortunately the data is
  # clean enough to where we can rely on there being two arrays of equal
  # length, and that they always fall within the same hour.
  def find_time_asleep
    @total_time_asleep = 0
    @wake_times.each_with_index do |wake_time, index|
      @total_time_asleep += ( wake_time - @sleep_times[index] )
    end
  end

  def sleep_ranges
    ranges = []
    @wake_times.each_with_index do |wake_time, index|
      ranges << (@sleep_times[index]..wake_time)
    end
    ranges
  end
end

file = File.open("sorted_parsed_input.txt")
guard_record = file.read

# Constructing a hash of all guards to try and enforce uniqueness on the ids.
# This might be a pretty silly idea that comes from how I've spent most of my
# time with Ruby as a Rails programmer. Maybe I should've just used a database
# from the beginning!
guards = {}

# A guard's id is only specified on the log lines when they start their shift,
# so their id isn't attached to other lines and has to be inferred from what
# the most recent shift start line was. This would be a bad idea with messier
# data!
most_recent_guard = 0

guard_record.each_line do |line|
  case line
  when /#[0-9]+/
    most_recent_guard = line[9..].to_i
    # new guards will show up here first
    if guards[most_recent_guard].nil?
      guards[most_recent_guard] = Guard.new(most_recent_guard)
    end
  when /s/
    guards[most_recent_guard].sleep_times << line[6..7].to_i
  when /w/
    # subtract 1 because this minute represents the moment they stop sleeping
    guards[most_recent_guard].wake_times << line[6..7].to_i - 1
  end  
end

# We'll have to iterate over all the guards to calculate their times asleep, so
# we'll compare their sleep times while we're at it to find the guy who saws
# the most logs
sleepiest_guard_id = 0
longest_sleep_time = 0

guards.each do |guard|
  guard[1].find_time_asleep
  if guard[1].total_time_asleep > longest_sleep_time
    sleepiest_guard_id = guard[1].id
    longest_sleep_time = guard[1].total_time_asleep
  end
end

sleepiest_guard = guards[sleepiest_guard_id]
puts "The sleepiest guard has id: #{sleepiest_guard.id}"

# Finally, convert the sleep/wake to ranges, iterate through all minutes of the
# hour, and find which minute is present in the most ranges. There's probably a
# much better way to do this and I'm sure my CS professors would tut-tut at my
# inelegant solution, but we only need to do it for one guard!

nap_times = sleepiest_guard.sleep_ranges

highest_nap_count = 0
highest_nap_minute = 0

(1..59).each do |minute|
  minute_count = 0
  nap_times.each do |nap|
    if nap.include? minute
      minute_count += 1
    end
  end

  if minute_count > highest_nap_count
    highest_nap_count = minute_count
    highest_nap_minute = minute
  end
end

puts "They slept the most at minute number #{highest_nap_minute}."
puts "Thus, the final answer is #{sleepiest_guard.id * highest_nap_minute}"
