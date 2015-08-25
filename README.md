#ActiveRecord Lite

An ORM inspired by the functionality of ActiveRecord.
Provides an interface to interact with data in relational databases.

##Phase 1: SQLObject

Creates a SQLObject class to interact with the database.
Generates methods found in ActiveRecord::Base.

##Phase 2: Searchable

Implements the ability to search using ::where.
Uses extend to allow us to mix in Searchable to our SQLObject class, adding all the module methods as class methods.

##Phase 3: Associatable

Belongs_to and has_many defined using an Associatable module, that we mix into SQLObject.

##Phase 4: Has_one_through

Implements has_one_through, which is a comination of two belongs_to associations.
