module CategoryDependentVariables
  
  def current_category
    cookies._selected_category
  end

  def current_category=(category_name)
    cookies._selected_category = category_name
  end

  def categories
    category_data.keys
  end

  def category_data
    {
      'urls' => {
        default_environment: 'Site',
        environment_term: 'url type',
        entry_term: 'url',
        context_term: 'Site',
        function_term: "What's at this url?",
        function_example: 'developer console, site status',
        execution_term: 'URL',
        execution_example: 'google.com'
      }
    }
  end

  def environment
    store.environments.where(name: environment_name, category: current_category).first
  end

  def environment_name
    name = cookies.send("_#{current_category}_environment_name")
  end

  def environment_name=(name)
    cookies.send("_#{current_category}_environment_name=",name)
  end

  def environment_names_for(category)
    store.environments.where(category: category).all.map { |env| env.name }
  end
  

  # def active_entry
  #   page.send("_#{current_category}_active_entry")
  # end

  # def active_entry=(entry)
  #   page.send("_#{current_category}_active_entry=",entry)
  # end

  # def set_active_entry(entry)
  #   page.send("_#{current_category}_active_entry=",entry)
  # end

  # def set_or_toggle_active_entry(entry)
  #   if active_entry == entry
  #     page.send("_#{current_category}_active_entry=",nil)
  #   else
  #     page.send("_#{current_category}_active_entry=",entry)
  #   end
  # end
end