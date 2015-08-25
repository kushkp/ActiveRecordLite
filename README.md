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



##Phase 4: Has_one_through
