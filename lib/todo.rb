require 'fileutils'

class Todo
  attr_accessor :name, :duedate, :completed

  def initialize(args={})
    @name = args[:name]
  end

  def self.build_from_questions
    args = {}
    print "Task name: "
    args[:name] = gets.chomp.strip

    todo = Todo.new(args)
    todo
  end

  def self.get_todos
    todos = []
    if TodoList.file_usable?
      file = File.new(TodoList.filepath, 'r')
      i = 0
      file.each_line do |line|
        # puts "#{i}: #{line}"
        i+=1
        todos << Todo.new.import_lines(line.chomp)
      end
      file.close
    end
    todos
  end

  def import_lines(line)
    line_array = line.split("\t")
    self.name = line_array[0].to_s
    return self
  end

  def save_to_list
    return false unless TodoList.file_usable?
    File.open(TodoList.filepath, 'a') do |line|
      line.puts "#{@name}\n"
    end
    true
  end

  def self.delete_from_list
    return false unless TodoList.file_usable?
    todos = get_todos

    print "> "
    task_to_delete = gets.chomp.strip.to_i
    todos.delete_at(task_to_delete-1)

    File.open(TodoList.filepath, 'w') do |line|
      todos.each do |t|
        line.puts "#{t.name}\n"
      end
    end

    return true
  end

end