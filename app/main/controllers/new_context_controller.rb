require 'main/mixins/category_dependent_variables'

module Main
  class NewContextController < Volt::ModelController
    include CategoryDependentVariables
    
    reactive_accessor :context_name

    def create
      if context_name.present?
        environment.then do |env|
          store.contexts.create({
            environment_id: env.id,
            name: context_name
            }).then do |created|

            call_toast "#{created.name} #{category_data[current_category][:context_term].downcase} created!"
            page._query = created.name

            clear_fields
          end.fail do |errors|
            errors.each do |error|
              flash._errors << "#{error.first} #{error.last}".gsub('_',' ')
            end
          end
        end
      else
        flash_empty_form_field_errors
      end
    end

    def clear_fields
      self.context_name = ''
    end

    def flash_empty_form_field_errors
      unless context_name.present?
        call_toast "#{category_data[current_category][:context_term]} cannot be blank."
      end
    end
  end
end
