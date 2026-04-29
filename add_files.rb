require 'xcodeproj'

project = Xcodeproj::Project.open('todo.xcodeproj')
app_target = project.targets.find { |t| t.name == 'todo' }
todo_group = project.main_group['todo']

def get_or_create_group(parent, name)
  parent[name] || parent.new_group(name, name)
end

{
  'Models'       => ['Todo.swift'],
  'Dependencies' => ['TodoRepository.swift'],
  'Resources'    => ['DesignTokens.swift'],
}.each do |folder, files|
  group = get_or_create_group(todo_group, folder)
  files.each do |filename|
    next if group.files.any? { |f| f.path == filename }
    ref = group.new_file(filename)
    app_target.source_build_phase.add_file_reference(ref)
  end
end

# Features/TodoList (중첩 그룹)
features_group = get_or_create_group(todo_group, 'Features')
todolist_group = get_or_create_group(features_group, 'TodoList')
['TodoListFeature.swift', 'TodoListView.swift'].each do |filename|
  next if todolist_group.files.any? { |f| f.path == filename }
  ref = todolist_group.new_file(filename)
  app_target.source_build_phase.add_file_reference(ref)
end

# ContentView.swift 제거
todo_group.files.select { |f| f.path == 'ContentView.swift' }.each do |ref|
  app_target.source_build_phase.remove_file_reference(ref)
  ref.remove_from_project
end

project.save
puts 'Done.'
