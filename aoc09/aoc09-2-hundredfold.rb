# Advent of Code Day 9 part 2
# Previously I just tried my part 1 vector-based solution and it just sat there
# whirring forever. I think the vector was getting too enormous to work with in
# any reasonable fashion. After looking around a little online, I thought I'd
# try a doubly-linked list. It found the answer in only 3.4 seconds! I wonder
# about how much memory Ruby must use in a problem space this large, but maybe
# it's okay if it's over and done with quickly.

class Marble
  attr_accessor :previous_marble, :next_marble, :value

  def initialize(value)
    @value = value
  end

  def insert_after_me(following_marble)
    following_marble.previous_marble = self
    @next_marble.previous_marble = following_marble
    following_marble.next_marble = @next_marble
    @next_marble = following_marble
  end

  def remove_me
    @previous_marble.next_marble = @next_marble
    @next_marble.previous_marble = @previous_marble
    # I think since Ruby is a garbage-collected language I don't have any way
    # to tell it to remove this marble from memory. Maybe I'm mistaken!
  end

  # The normal play procedure - insert a new marble after this marble's
  # successor. Then return this new marble because it becomes the objective
  # marble in the next round of the game.
  def place_new_marble(new_marble)
    @next_marble.insert_after_me(new_marble)
    new_marble
  end

  # The player had a marble that was a multiple of 23. Go back 7 marbles, find
  # that marble's point value, and then remove it. The objective marble is the
  # one that was following it.
  def lucky23(current_marble)
    remove_this_marble = current_marble
    7.times do
      remove_this_marble = remove_this_marble.previous_marble
    end
    # puts "I'm supposed to remove the marble with value #{remove_this_marble.value}"
    remove_this_marble.remove_me

    # have to return two items
    [remove_this_marble.value, remove_this_marble.next_marble]
  end
end

# how many marbles should the game last?
ending_marble = 7103200
# how many players?
player_count = 441

puts "This game will have #{player_count} players and end at marble #{ending_marble}."

# Players are just a hash with their number as the key and their score as the
# value.
players = {}
1..player_count.times do |i|
  players.merge!({ (i + 1) => 0 })
end

# The first marble is kind of a tricky case. We have to tell it that it is its
# own predecessor and successor.
starting_marble = Marble.new(0)
starting_marble.previous_marble = starting_marble
starting_marble.next_marble = starting_marble
current_marble = starting_marble

new_marble_number = 1

current_player_number = 0

(ending_marble - 1).times do
  current_player_number = (current_player_number % player_count) + 1

  # First, see if the marble number is divisible by 23, because then the elf
  # gets points!
  if new_marble_number % 23 == 0
    score_and_new_marble = current_marble.lucky23(current_marble)
    new_points = new_marble_number + score_and_new_marble[0]
    current_marble = score_and_new_marble[1]
    players[current_player_number] += new_points

  else
    # This was a normal marble.
    new_marble = Marble.new(new_marble_number)
    current_marble = current_marble.place_new_marble(new_marble)
  end

  new_marble_number += 1
end

puts "The max score was: #{ players.values.max }"
