require 'main/mixins/category_dependent_variables'

module Main
  class ContextController < Volt::ModelController
    include CategoryDependentVariables

    reactive_accessor :show_all
    reactive_accessor :active_entry
    reactive_accessor :new_form_active
    
    def index
      self.active_entry = nil
      self.show_all = false
    end

    def remove(entry)
      store.entries.delete(entry)
    end

    def toggle_new_form
      self.new_form_active = !new_form_active
    end

    def toggle_show_all
      self.show_all = !show_all
    end

    def showing_all_class
      'showing-all' if show_all
    end

    def badge_text
      if show_all
        'collapse'
      else
        # matching_entries.count.then { |value| "#{[value - 3, 0].max} more..." }
        # matching_entries.count.then { |value| "show all #{value}" }
        'expand'
      end
    end

    def managing_an_entry?
      active_entry.present?
    end

    def managing?(entry)
      self.active_entry == entry
    end

    def reset_active_entry
      self.active_entry = nil
    end

    def set_or_toggle_active_entry(entry)
      if managing?(entry)
        self.active_entry = nil
      else
        self.active_entry = entry
      end
    end

    def active_class(entry)
      managing?(entry) ? 'active' : ''
    end

    def entries_query
      query = page._query.downcase
      context_name = name.downcase

      words = query.strip.split(/\s+/)

      words.each do |word|
        if matching_segment = context_name.slice(word)
          query = query.sub(matching_segment,'')
        end
      end

      query
    end

    def matching_entries(skip: 0, limit: 500)
      return entries if page._query.nil?

      words = entries_query.strip.split(/\s+/)

      return entries if words.empty?

      queries = (words).map { |string| 
        { function: { '$regex' => string, '$options' => 'i' } }
      }

      # Skip and limit don't seem to be working at the moment
      entries.where({'$and' => queries}).skip(skip).limit(limit)
    end

    def matching_entries_part(part, of: 2)
      matching_entries.count.then do |count|

        part_size = (count.to_f / of.to_f).ceil
        skip = part_size * (part - 1)

        matching_entries(skip: skip, limit: part_size)
      end
    end
  end
end