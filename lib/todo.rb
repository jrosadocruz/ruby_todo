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

  def delete_from_list
    return false unless TodoList.file_usable?
    File.open('temp.txt', 'w') do |file|
      File.foreach(TodoList.filepath) do |line|
        file.puts line unless line.chomp.strip == out_file.chomp.strip
      end
    end
    # puts out_file

    # out_file do |out_file|
      # puts out_file
      # File.foreach(TodoList.filepath) do |line|
        # out_file.puts line unless line.chomp.strip == out_file.chomp.strip
      # end
    # end
    out_file.close
    # FileUtils.mv(new_file, TodoList.filepath)
    return true
  end

end