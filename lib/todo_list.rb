require 'todo.rb'

class TodoList
  attr_accessor :name

  @@filepath = nil
  @@actions = ['list','add','delete','quit']

  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end

  def self.filepath
    @@filepath
  end

  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.writable?(@@filepath)
    return false unless File.readable?(@@filepath)
    return true
  end

  def self.file_exists?
    @@filepath && File.exists?(@@filepath)
  end

  def self.create_list
    File.open(@@filepath, 'w') unless file_exists?
  end

  def initialize(path=nil)
    TodoList.filepath = path
    if TodoList.file_usable?
      puts "List has been load"
    elsif TodoList.create_list
      puts "Creating list"
    else
      puts "Exiting"
      exit!
    end
  end

  def run!
    welcome_msg
    result = nil
    until result == :quit
      action = get_actions
      result = do_action(action)
    end
    bye_msg
  end

  def get_actions
    action = nil
    until @@actions.include?(action)
      puts "Actions: #{@@actions.join(", ")}" if action
      print "> "
      user_response = gets.chomp
      action = user_response.downcase.strip
    end
    action
  end

  def do_action(action)
    case action
    when 'list'
      list
    when 'add'
      add
    when 'delete'
      delete_task
    when 'quit'
      return :quit
    else
      puts "I don't understand that command"
    end
  end

  def add
    puts "Add a new task"
    todo = Todo.build_from_questions
    if todo.save_to_list
      puts "A todo has bee created"
    else
      puts "Save Error"
    end
  end

  def list
    puts "\n\nListing Todos\n"
    todos = Todo.get_todos
    # puts todos.inspect
    todos.each_with_index do |todo, i|
      puts "#{i+1}: #{todo.name}"
    end
  end

  def delete_task
    print "Which task do you wish to delete? (write it's number)"
    list
    todos = Todo.get_todos

    print "> "
    task_to_delete = gets.chomp.strip.to_i
    todos.delete_at(task_to_delete-1)

    File.open(TodoList.filepath, 'w') do |line|
      todos.each do |t| puts
        line.puts "#{t.name}\n"
      end
    end

  end

  def welcome_msg
    puts "<<< Welcome to the todo list >>>".center(60)
  end

  def bye_msg
    puts "<<< Bye. Have a nice day. >>>".center(60)
  end

end