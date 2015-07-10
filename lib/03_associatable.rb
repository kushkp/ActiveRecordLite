require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    self.foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    self.class_name = options[:class_name] || "#{name}".singularize.capitalize
    self.primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    self.foreign_key = options[:foreign_key] ||
      "#{self_class_name.downcase}_id".to_sym
    self.class_name = options[:class_name] || "#{name.singularize.capitalize}"
    self.primary_key = options[:primary_key] || :id
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    define_method(name) do
      fk = send(options.foreign_key)
      pk = options.primary_key
      cn = options.model_class
      results = DBConnection.execute(<<-SQL)
        SELECT
          *
        FROM
          #{options.table_name}
        WHERE
          #{pk} = #{fk};
      SQL

      cn.new(results.first)
    end
  end

  def has_many(name, options = {})

  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end
