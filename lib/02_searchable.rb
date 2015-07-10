require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_cond = params.keys.map do |attribute|
      "#{attribute} = ?"
    end.join(" AND ")

    results = DBConnection.execute(<<-SQL, *(params.values))
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_cond};
    SQL

    results.map do |attributes|
      self.new(attributes)
    end
  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end
