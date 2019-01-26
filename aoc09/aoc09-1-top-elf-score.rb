# Advent of Code Day 9 part 1
# Once more, I don't claim to make anything much more than clumsy use of my
# tools, but somehow, it worked.

# how many marbles should the game last?
ending_marble = 71032
# how many players?
player_count = 441

puts "This game will have #{player_count} players and end at marble #{ending_marble}."

# Players are just a hash with their number as the key and their score as the
# value.
players = {}
1..player_count.times do |i|
  players.merge!({ (i + 1) => 0 })
end

# Representing the marble circle as an array. "Clockwise" refers to traversing
# forward and "Counterclockwise" will be backward.
circle = []

# The game starts with marble number 0 in the center.
circle << 0

new_marble_number = 1
# make the first move
circle << new_marble_number
new_marble_number += 1

# If this were something like C, I'd use a pointer, but if Ruby has pointers
# then I must have slept through that class!
current_marble_index = 1

current_player_number = 1 # player 1 took his turn outside the loop

(ending_marble - 1).times do
  current_player_number = current_player_number == player_count ? 1 :
    current_player_number + 1

  # First, see if the marble number is divisible by 23, because then the elf
  # gets points!
  if new_marble_number % 23 == 0
    # Remove the marble 7 pieces previous to the current marble. This gets
    # complex when the marble is near the start.
    remove_at_this_index = nil
    unless current_marble_index <= 7
      remove_at_this_index = current_marble_index - 7
    else
      remove_at_this_index = circle.size + current_marble_index - 7
    end

    current_marble_index = remove_at_this_index
    new_points = new_marble_number + circle[remove_at_this_index]
    # puts "Player #{current_player_number} gets #{new_points} points."
    players[current_player_number] += new_points
    circle.delete_at(remove_at_this_index)

  else
    # This was a normal marble.
    # Where to insert? I like to think of it as "after the next one" - insert at
    # the spot after the previous insertion spot.

    # But if the current marble is the last one, instead insert it after the 0
    # marble, which is index 1 in the array.
    if current_marble_index + 1 >= circle.size
      circle.insert(1, new_marble_number)
      current_marble_index = 1
    else
      circle.insert(current_marble_index + 2, new_marble_number)
      current_marble_index += 2 
    end
  end

  new_marble_number += 1
end

puts "The max score was: #{ players.values.max }"
