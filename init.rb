### SIMPLE TODO TERMINAL APP ###
#
# Launch this Ruby file from the command line
# to get started.

APP_ROOT = File.dirname(__FILE__)
$:.unshift( File.join(APP_ROOT, 'lib') )

require 'todo_list.rb'

todo_list = TodoList.new('todo.txt')
todo_list.run!