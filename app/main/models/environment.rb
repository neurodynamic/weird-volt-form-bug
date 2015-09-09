class Environment < Volt::Model
  has_many :contexts

  field :category, String
  field :name, String
  field :icon, String

  validate :category, presence: true
  validate :name, presence: true
end