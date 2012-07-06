## Overview

CoreDataManager is a simple core data management library that supports following SQL operations:

-  Insert 
-  Update 
-  Delete 
-  Search

### Creating shared Instance and global context
* create a shared Instance of `CoreDataManager` by the following code:

		+ (CoreDataManager *)sharedCoreDataManager;

* A global `NSManagedObjectContext` (one for all database operations throught) will be created using following method:

		+ (NSManagedObjectContext *)globalContext;

	

#### Insert
*Insert a record to an existing table*

	+ (NSError *)insertARecordWithRecordValues:(NSDictionary *)values ToTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context;



#### Update
*Update a record for a property (if the record exists) in an existing table*

	+ (NSError *)updateARecord:(NSManagedObject *)record WithNewRecordValues:(NSDictionary *)values InTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context;


#### Delete
*Delete a record from an existing table*
	
	+ (NSError *)deleteARecord:(NSManagedObject *)record InContext:(NSManagedObjectContext *)context;

#### Search
1. *fetch all records from a single table*

		+ (NSMutableArray *)fetchAllRecordsFromTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context;
		
2. *fetch all records sorted by certain attribute*

		+ (NSMutableArray *)fetchAllRecordsFromTable:(NSString *)tableName sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

3. *fetch records matched by a predicate*

		+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName MatchedByPredicate:(NSPredicate *)predicate InContext:(NSManagedObjectContext *)context;

4. *fetch records matched by a predicate, and sorted by certain attribute*

		+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName MatchedByPredicate:(NSPredicate *)predicate sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

5. *fetch records defined by the criteria in `NSFetchRequest`*

		+ (NSMutableArray *)fetchRecordsWithFetchRequest:(NSFetchRequest *)request InContext:(NSManagedObjectContext *)context;

6. *fetch records with a value for an attribute*

		+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName AttributeName:(NSString *)attribute AndValue:(id)value InContext:(NSManagedObjectContext *)context;

7. *fetch records with a value for an attribute, and sorted by certain attribute*

		+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName AttributeName:(NSString *)attribute AndValue:(id)value sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

8. *fetch the unique record with the given predicate*

		+ (id)fetchFirstRecordFromTable:(NSString *)tableName withPredicate:(NSPredicate *)predicate InContext:(NSManagedObjectContext *)context;

9. *fetch the first record with the given predicate, and sorted by certain attribute*

		+ (id)fetchFirstRecordFromTable:(NSString *)tableName withPredicate:(NSPredicate *)predicate sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

### More Features
Obviously this is a very very simple core-data handler, for complicated operations you can look into [MagicalRecord](http://github.com/magicalpanda/MagicalRecord). More Features will be updated as required in future.

**Thank You ! **

