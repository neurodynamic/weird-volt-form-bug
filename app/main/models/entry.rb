class Entry < Volt::Model
  belongs_to :context

  field :context_id, String
  field :function, String
  field :execution, String
  field :extra_info, String
  field :example, String
  field :tag_list, String
  field :slug, String

  validate :context_id, presence: true
  validate :function, presence: true
  validate :execution, presence: true

  validate do
    if function.present? and execution.present? and context_id.present?
      validate_uniqueness_within_context
    end
  end



  private

  def validate_uniqueness_within_context

    context.then do |cxt|
      store.entries.where(function: function, execution: execution, context_id: context_id).first.then do |match|
        if match and match.id != _id
          { entry: ["\"#{function}: #{execution}\" already exists for #{cxt.name}"] }
        else
          {}
        end
      end
    end
  end
end