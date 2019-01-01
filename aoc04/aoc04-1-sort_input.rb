# Advent of Code Day 4 Part 1
# This simply takes the input and sorts it by date and time, since the data is
# completely mixed up, and then reformats it in an even simpler format for
# easier parsing

require 'date'

# events will be recorded as a struct with their timestamp and type
WallScrawl = Struct.new(:timestamp, :type) do
  def to_ary
    [timestamp, type]
  end
end

file = File.open("input.txt")
scrawlings = file.read

# All events will be stuffed in this array to be sorted later - this would
# probably be unfeasible given enormous datasets. Fortunately we're all the
# beneficiaries of years of work of talented hardware engineers and I can make
# up for my lack of cleverness through sheer silicon might!
all_events = []

scrawlings.each_line do |line|
  # looking at the data, we can assume the year is always 1518 and that the
  # times are very well-sorted - no inconsistencies apart from the Guard ID
  month = line[6..7].to_i
  day = line[9..10].to_i
  hour = line[12..13].to_i
  minute = line[15..16].to_i

  event_type = ""

  case line
  when /begin/
    # in this case we have to identify the ID of the guard
    event_type = line[/#[0-9]+/]
  when /sleep/
    event_type = "s"
  when /wake/
    event_type = "w"
  else
    puts "Error! Poorly formed input! #{line}"
  end
  # fortunately the time zone is irrelevant
  new_date = DateTime.new(1518, month, day, hour, minute)
  all_events << WallScrawl.new(new_date, event_type)
end

# as with previous problems, Ruby feels like cheating
# this is another part where I can hide ineptitude behind hardware power
all_events.sort! { |a, b| a.timestamp <=> b.timestamp }

print_file = ""
all_events.each do |event|
  print_file << "#{event.timestamp.strftime("%m%d%H%M")}#{event.type}\n"
end

File.write("./sorted_parsed_input.txt", print_file)

