
def find_or_create_entry(category, environment, context, function, execution, example: nil, extra_info: nil)
  entry_info = "[#{category}] [#{environment}] [#{context}] [#{function}] [#{execution}] entry"
  puts "\nENTRIES: Finding or creating #{entry_info}..."
  environments = Volt.current_app.store.environments
  contexts = Volt.current_app.store.contexts
  entries = Volt.current_app.store.entries

  entry = nil

  env = find_or_create_environment(category, environment)
  context_id = find_or_create_context(category, environment, context).id

  entries.where(
    context_id: context_id,
    function: function,
    execution: execution
  ).first.then do |result|

    if result
      puts "Found pre-existing #{entry_info}."
      return entry = result

    else
      entries.create(
        context_id: context_id,
        function: function,
        execution: execution,
        extra_info: extra_info,
        example: example

      ).then do |result|
        puts "Created #{entry_info}."
        return entry = result

      end.fail do |error|
        puts "Failed to create #{entry_info}."

      end
    end
  end

  entry
end


def find_or_create_context(category, environment, name)
  context_info = "[#{category}] [#{environment}] [#{name}] context"
  puts "Finding or creating #{context_info}..."

  environments = Volt.current_app.store.environments
  contexts = Volt.current_app.store.contexts

  context = nil
  environment_id = find_or_create_environment(category, environment).id

  contexts.where(
    environment_id: environment_id,
    name: name
  ).first.then do |result|

    if result
      puts "Found pre-existing #{context_info}."
      return context = result

    else
      contexts.create(
        environment_id: environment_id,
        name: name

      ).then do |created|
        puts "Created #{context_info}."
        return context = created

      end.fail do |error|
        puts "Failed to create #{context_info}."

      end
    end
  end

  context
end


def find_or_create_environment(category, name, icon = 'question-circle')
  environment_info = "[#{category}] [#{name}] environment"
  puts "Finding or creating #{environment_info}..."

  environments = Volt.current_app.store.environments
  environment = nil

  environments.where(
    category: category,
    name: name
  ).first.then do |result|

    if result
      puts "Found pre-existing #{environment_info}."
      return environment = result
    else
      environments.create(
        category: category,
        name: name,
        icon: icon

      ).then do |env|
        puts "Created #{environment_info}."
        return environment = env

      end.fail do |error|
        puts "Failed to create #{environment_info}."

      end
    end
  end

  environment
end