class Volt::Model

  private

  def validate_uniqueness_scope(*attribute_array)
    attributes_hash = Hash[attribute_array.map { |i| [ i, send(i)] }]

    store.send(self.class.name.downcase.pluralize).where(attributes_hash).count.then do |count|
      if count > 0
        { self.class.name.downcase.to_sym => ["#{attributes_hash.values.join(', ')} already exists."] }
      else
        {}
      end
    end
  end
end