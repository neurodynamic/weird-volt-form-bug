require 'main/mixins/category_dependent_variables'

module Main
  class NewEntryController < Volt::ModelController
    include CategoryDependentVariables

    reactive_accessor :buffer

    def index
      self.buffer = entries.buffer
      self.buffer.context_id = id
    end

    def create_entry
      if buffer.function.present? and buffer.execution.present?

        buffer.save!.then do |new_entry|
          call_toast "Created #{new_entry.function}!"
          close_form
        end.fail do |errors|

          errors.each do |error|
            flash._errors << "#{error.first} #{error.last}".gsub('_',' ')
          end
        end
      else
        flash_empty_form_field_errors
      end
    end

    def close_form
      trigger 'finished'
    end

    def flash_empty_form_field_errors
      unless buffer.function.present?
        call_toast "Please fill in #{category_data[current_category][:function_term]}"
      end

      unless buffer.execution.present?
        call_toast "Please fill in #{category_data[current_category][:execution_term]}"
      end
    end
  end
end
