# Advent of Code Day 7 part 2
# Once again I feel like I'm wading into concepts that have been well-solved by
# many people long before me! But I suppose that I'll have a greater
# appreciation for these topics and problems once I've made my own amateur stab
# at them!
# This one took me several tries and several incorrect answers.

# An elf, basically. They perform a second of work at their job until they
# finish. As it stands, the code doesn't perform the example correctly - jobs
# that take one second end up taking at least two. But in the final problem
# they take much longer than that, so I decided to ignore that edge case.
class Worker
  attr_accessor :busy, :job_id

  def initialize
    @busy = false
    @job_id = nil
    @remaining_job_time = 0
  end

  # simulates the worker's actions taken once per second
  def work
    if @busy && @remaining_job_time > 0
      @remaining_job_time -= 1
    end
  end

  # as defined in the example, the second a job is assigned, the worker performs 
  # one second of work on it
  def assign_job(job_id, job_time)
    @busy = true
    @remaining_job_time = job_time - 1
    @job_id = job_id
  end

  def are_you_finishing?
    if @remaining_job_time <= 0
      @busy = false
      former_id = @job_id
      @job_id = nil
      @remaining_job_time = nil
      former_id
    else
      false
    end
  end

end

# As defined in the problem, the amount of time it takes to complete each job
completion_time = {}
completion_time_index = 61 # The time it takes job "A" to complete
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
  print "#{current_time}\t"
  potential_steps.sort!
  completed_this_turn = []

  workers.each do |worker|
    # if the worker has a job, perform a second of work on it
    worker.work
    if worker.busy
      print worker.job_id + "\t"
      finished_job = worker.are_you_finishing?
      if finished_job
        completed_this_turn << finished_job
      end
    elsif !worker.busy && !potential_steps[0].nil?
      # this worker is idle and a job is available: time to work!
      worker.assign_job(potential_steps[0], completion_time[ potential_steps[0]] )
      print potential_steps[0] + "\t"
      potential_steps.delete_at(0)
    else
      print ".\t"
    end
  end

  # wrap up any jobs completed at this turn - this is necessary because
  # otherwise workers snipe the child jobs on the same second another
  # one finishes
  completed_this_turn.each do |job_id|
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

  print "\n"
  current_time += 1
end

puts "Here's the final order of completion: #{final_order}"
puts "It took #{current_time} seconds to complete all of them."
