require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    cols = DBConnection.execute2(<<-SQL)
      SELECT *
      FROM
        #{table_name};
    SQL
    cols.first.map { |col_str| col_str.to_sym }
  end

  def self.finalize!
    columns.each do |col|
      define_method("#{col}") do
        attributes[col.to_sym]
      end

      define_method("#{col}=") do |value|
        attributes[col.to_sym] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    t_name = self.name.tableize
    @table_name.nil? ? t_name : @table_name
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name};
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map do |obj|
      self.new(obj)
    end
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = #{id};
    SQL

    self.new(results.first)
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_sym = attr_name.to_sym
      unless self.class.columns.include?(attr_sym)
        raise "unknown attribute '#{attr_name}'"
      end

      self.send("#{attr_sym}=".to_sym, value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |col|
      send(col)
    end
  end

  def insert
    cat = self.class
    col_names = cat.columns.join(", ")
    question_marks = (["?"] * cat.columns.length).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{cat.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_line = self.class.columns.map do |attr_name|
      "#{attr_name} = ?"
    end.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        id = #{self.id};
    SQL
  end

  def save
    self.id.nil? ? insert : update
  end
end
