#ActiveRecord Lite

An ORM inspired by the functionality of ActiveRecord.
Provides an interface to interact with data in relational databases.

##Phase 1: 'SQLObject'

Creates a 'SQLObject' class to interact with the database.
Generates methods found in 'ActiveRecord::Base':
  - '::all' returns an array of all records in the database
  - '::find' searches the database for a single record by id(primary_key)
  - '#insert' inserts a new row, representing the 'SQLObject' into the table
  - '#update' updates the database row that corresponds to the given 'SQLObject'
  - '#save' calls either 'insert' or 'update', depending on whether the 'SQLObject' exists in the database

##Phase 2: 'Searchable'

Implements the ability to search using ''::where'.
Uses 'extend' to allow us to mix in 'Searchable' to our 'SQLObject' class, adding all the module methods as class methods.

##Phase 3: 'Associatable'

'Belongs_to' and 'has_many' defined using an 'Associatable' module, that we mix into 'SQLObject'.

##Phase 4: 'has_one_through'

Implements 'has_one_through', which is a comination of two 'belongs_to' associations.
