# Advent of Code Day 4 Part 2
# This is largely based off of the code in part 1. This time we're just looking
# for the the guard who sleeps the most consistently - they have the greatest
# number of times asleep at a given minute than any other guard. The data looks
# intimidating but there actually aren't that many guards, so even my
# inefficient solutions shouldn't tax your average system too much.

class Guard
  attr_accessor :id, :sleep_times, :wake_times, :sleep_count_by_minute

  def initialize(id)
    @id = id
    @sleep_times = []
    @wake_times = []
    @sleep_count_by_minute = []
    @sleep_ranges = []
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

  def sleep_record
    ranges = []
    @wake_times.each_with_index do |wake_time, index|
      ranges << (@sleep_times[index]..wake_time)
    end

    (1..59).each do |minute|
      snooze_count = 0
      ranges.each do |nap|
        if nap.include? minute
          snooze_count += 1
        end
      end
      @sleep_count_by_minute[minute] = snooze_count
    end
    # For some reason the first entry is nil - I don't quite understand why,
    # but since the solution works, I'm willing to overlook it. If it compiles,
    # ship it!
    @sleep_count_by_minute
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

# As we calculate the number of naps, keep track of the nap king
greatest_napper_id = 0
greatest_napper_count = 0
greatest_napping_minute = 0

guards.each do |guard|
  # calculate their sleep frequencies
  nap_counts = guard[1].sleep_record
  nap_counts.each_with_index do |sleep_count, index|
    if !sleep_count.nil? && sleep_count > greatest_napper_count
      greatest_napper_id = guard[1].id
      greatest_napper_count = sleep_count
      greatest_napping_minute = index
    end
  end
end

puts "I believe I've found the serial napper! It's guard number #{greatest_napper_id}, who napped #{greatest_napper_count} times at minute #{greatest_napping_minute}"
puts "This means the final product is #{greatest_napper_id * greatest_napping_minute}"


