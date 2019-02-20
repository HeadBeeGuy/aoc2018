# Advent of Code Day 13 part 1
# This was relatively easy to conceive and code up, but it's quite verbose. I
# can only imagine that there's a more elegant way to simulate everything, but
# the solution finished in less than a second on my laptop, so I'll call it
# good for the time being!
class Cart
  attr_accessor :position, :direction
  def initialize(position, direction) # I keep getting bugs by spelling "initialize" wrong
    @position = position
    @direction = direction
    @last_turn_direction = :right # turn direction order is left -> straight -> right
  end

  # Call this every unit of time to move to the next space and return the new
  # position
  def advance_position
    case @direction
    when :up
      new_position = [@position[0], @position[1] - 1]
      determine_heading(new_position)
      @position = new_position
    when :down
      new_position = [@position[0], @position[1] + 1]
      determine_heading(new_position)
      @position = new_position
    when :left
      new_position = [@position[0] - 1, @position[1]]
      determine_heading(new_position)
      @position = new_position
    when :right
      new_position = [@position[0] + 1, @position[1]]
      determine_heading(new_position)
      @position = new_position
    end
    @position
  end

  private
    # Alter the cart's direction if it encounters a bend or intersection on the
  # track.
    def determine_heading(new_position)
      case $track[[new_position[0], new_position[1]]]
      when "\\"
        if @direction == :right || @direction == :left
          turn_right
        else
          turn_left
        end
      when "/"
        if @direction == :right || @direction == :left
          turn_left
        else
          turn_right
        end
      when "+"
        # turn order goes left -> straight -> right
        if @last_turn_direction == :right
          @last_turn_direction = :left
          turn_left
        elsif @last_turn_direction == :left
          @last_turn_direction = :straight
          # no turn necessary
        else # last turn was straight
          @last_turn_direction = :right
          turn_right
        end
      end
    end

    # These functions are awkward! In Rails I would use Rails-style enums, but
    # I don't know how I would use something like that in regular Ruby, and I'm
    # working on this offline besides!
    def turn_left
      case @direction
      when :up
        @direction = :left
      when :right
        @direction = :up
      when :down
        @direction = :right
      when :left
        @direction = :down
      end
    end

    def turn_right
      case @direction
      when :up
        @direction = :right
      when :right
        @direction = :down
      when :down
        @direction = :left
      when :left
        @direction = :up
      end
    end
end

file = File.open("input.txt")
track_file = file.read

$track = {} # I know global variables aren't encouraged but I hope it makes sense here
carts = []

# Construct the track - 2-dimensional array of characters. Blank spots aren't
# saved, which will save some pittance of memory.
x = 0
y = 0
track_file.each_line do |line|
  x = 0
  line.rstrip! # only remove the trailing whitespace
  # Carts only appear to start out on horizontal or vertical pieces of the
  # track
  line.each_char do |char|
    case char
    when "-", "|", "/", "\\", "+"
      $track[[x,y]] = char
    when "v"
      $track[[x,y]] = "|"
      carts << Cart.new([x,y], :down)
    when "^"
      $track[[x,y]] = "|"
      carts << Cart.new([x,y], :up)
    when "<"
      $track[[x,y]] = "-"
      carts << Cart.new([x,y], :left)
    when ">"
      $track[[x,y]] = "-"
      carts << Cart.new([x,y], :right)
    end
    x += 1
  end
  y += 1
end

collision = false
until collision == true
  cart_locations = {}
  carts.each do |cart|
    new_position = cart.advance_position
    if cart_locations[new_position].nil?
      cart_locations.merge!({new_position => 1})
    else
      puts "Oh no! Two carts collided at #{new_position}!"
      collision = true
    end
  end
end
