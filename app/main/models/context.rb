class Context < Volt::Model
  belongs_to :environment
  has_many :entries

  field :environment_id, String
  field :name, String

  validate :name, presence: true
  validate :environment_id, presence: true

  validate do
    if name.present? and environment_id.present?
      validate_name_uniqueness_within_environment
    end
  end



  private

  def validate_name_uniqueness_within_environment
    environment.then do |env|
      store.contexts.where(name: name, environment_id: environment_id).count.then do |count|
        if count > 0
          { name: ["already exists for #{env.name}"] }
        else
          {}
        end
      end
    end
  end
end