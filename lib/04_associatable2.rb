require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    # assoc_options[name] = BelongsToOptions.new(name, options)

    through_options = self.assoc_options[through_name]

    define_method(name) do
      # send(through_name).send(source_name) #LOLOLOL
      through_fk_val = send(through_options.foreign_key)
      through_pk = through_options.primary_key
      through_cn = through_options.model_class
      source_options = through_options.model_class.assoc_options[source_name]

      source_fk = (source_options.foreign_key)
      source_pk = source_options.primary_key
      source_cn = source_options.model_class

      results = DBConnection.execute(<<-SQL)
        SELECT
          b.*
        FROM
          #{through_options.table_name} AS a
        JOIN
          #{source_options.table_name} AS b
        ON
          a.#{source_fk} = b.#{source_pk}
        WHERE
          a.#{through_pk} = #{through_fk_val};


      SQL
      # results.find { |result| result.source }
      return_object = results.map { |attributes| source_cn.new(attributes) }
      return_object.first
    end

  end
end
