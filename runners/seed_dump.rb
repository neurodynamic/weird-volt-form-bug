require 'fileutils'

file_path = "runners/dump_from_#{Date.today.strftime('%Y_%m_%d')}.rb"

FileUtils.touch(file_path)

File.open(file_path, "w") do |file| 
  file.puts "require_relative 'find_or_create_methods'"
  file.puts

  Volt.current_app.store.entries.all.each do |entry|
    puts "Backing up entry with id: #{entry.id}"

    Volt.current_app.store.contexts.where(id: entry.context_id).first.then do |context|
      Volt.current_app.store.environments.where(id: context.environment_id).first.then do |environment|

        arguments = []
        arguments << "\"#{environment.category}\""
        arguments << "\"#{environment.name}\""
        arguments << "\"#{context.name}\""
        arguments << "\"#{entry.function.gsub('"','\"')}\""
        arguments << "\"#{entry.execution.gsub('"','\"')}\""
        arguments << "extra_info: \"#{entry.extra_info.gsub('"','\"')}\"" if entry.extra_info
        arguments << "example: \"#{entry.example.gsub('"','\"')}\"" if entry.example

        puts "Attributes: #{arguments}"

        argument_string = arguments.join(", ")
        file.puts "find_or_create_entry(#{argument_string})"
      end
    end
  end
end