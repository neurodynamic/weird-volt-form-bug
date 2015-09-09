require 'main/mixins/category_dependent_variables'

module Main
  class ManageEntryController < Volt::ModelController
    include CategoryDependentVariables

    reactive_accessor :mode
    reactive_accessor :buffer

    def index
      self.mode = 'preview'
      self.buffer = model.buffer
    end

    def form_mode?
      self.mode == 'form'
    end

    def preview_mode?
      self.mode == 'preview'
    end

    def open_form
      self.mode = 'form'
    end

    def close_form
      self.mode = 'preview'
    end

    def update
      if buffer.function.present? and buffer.execution.present?
        buffer.save!

        close_form
      else
        flash_empty_form_field_errors
      end
    end

    def destroy
      trigger('flagged_for_deletion', model)
      # model.then do |target|
      #   store.entries.delete(target).then do |success|
      #     stop_managing
      #   end
      # end
    end

    def stop_managing
      trigger('finished')
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
