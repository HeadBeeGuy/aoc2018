# Advent of Code Day 7 part 2
# Once again I feel like I'm wading into concepts that have been well-solved by
# many people long before me! But I suppose that I'll have a greater
# appreciation for these topics and problems once I've made my own amateur stab
# at them!

class Worker
  def initialize
    @busy = false
    @job_end_time = 0
    @job_id = nil
  end

  def assign_job(job_id, current_time, completion_time)
    @busy = true
    @job_id = job_id
    @job_end_time = current_time + completion_time[job_id] - 1
    puts "#{current_time}: Job #{job_id} has been assigned. Completion time: #{@job_end_time}"
  end

  def busy?
    @busy
  end

  def are_you_finishing?(current_time)
    if @busy && @job_end_time <= current_time
      @busy = false
      @job_end_time = nil
      @job_id
    else
      false
    end
  end
end

# As defined in the problem, the amount of time it takes to complete each job
completion_time = {}
completion_time_index = 61
("A".."Z").to_a.each do |letter|
  completion_time[letter] = completion_time_index
  completion_time_index += 1
end

no_prereqs = []
potential_steps = []
step_tree = {}
final_order = ""
current_time = 0
worker_count = 5

workers = []
worker_count.times do
  workers << Worker.new
end

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

until final_order.length >= 26
  # puts "#{current_time}: New second. Potential steps: #{potential_steps}"
  potential_steps.sort!
  completed_this_turn = []

  workers.each do |worker|
    if worker.busy?
      # check if this is the last second that the job is active
      job_id = worker.are_you_finishing?(current_time)
      if job_id
        completed_this_turn << job_id
      end
    elsif !potential_steps[0].nil?
      # throw the next available job at this worker
      # puts "#{current_time}: Found free worker. Assigning job #{potential_steps[0]}"
      worker.assign_job(potential_steps[0], current_time, completion_time)
      potential_steps.delete_at(0)
    end
  end

  # wrap up any jobs completed at this turn - this is necessary because
  # otherwise workers snipe the child jobs on the same second another
  # one finishes
  completed_this_turn.each do |job_id|
    puts "#{current_time}: Job #{job_id} is finished."
    final_order << job_id
    step_tree[job_id][:children].each do |new_step|
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

  current_time += 1
end

puts "Here's the final order of completion: #{final_order}"
puts "It took #{current_time - 1} seconds to complete all of them."
