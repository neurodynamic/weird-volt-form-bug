require 'main/mixins/category_dependent_variables'

module Main
  class EntriesController < Volt::ModelController
    include CategoryDependentVariables

    def index
      cookies._selected_category = 'urls'
      cookies._urls_environment_name = 'Site'

      flash_search_bar_until_focus if new_visitor?
      record_visit
    end

    def search_label
      "Search for #{environment_name} #{category_data[current_category][:entry_term]}s..."
    end

    def matching_contexts
      return environment.contexts if page._query.nil?

      words = page._query.strip.split(/\s+/)

      return environment.contexts if words.empty?

      queries = (words).map { |string| 
        { name: { '$regex' => string, '$options' => 'i' } }
      }

      environment.contexts.where({'$or' => queries})
    end



    private

    def new_visitor?
      cookies._visit_count.nil?
    end

    def record_visit
      if new_visitor?
        cookies._visit_count = 1
      else
        cookies._visit_count = cookies._visit_count.to_i + 1
      end
    end

    def flash_search_bar_until_focus
      Document.ready? do
        Element['input#search'].add_class('faulty-neon')
        
        Element['input#search'].on(:focus) do |evt|
          evt.current_target.remove_class('faulty-neon')
        end
      end
    end
  end
end
