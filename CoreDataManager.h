//
//  CoreDataManager.h
//
//  Created by Suraj on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//	This core data manager is a simple core-data manager that only implements basic sql operations: insert, delete, update and search.


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataManager : NSObject {
	NSManagedObjectContext * managedObjectContext;
	NSManagedObjectModel * managedObjectModel;
	NSPersistentStoreCoordinator * persistentStoreCoordinator;
}

// get a singleton object of this class
+ (CoreDataManager *)sharedCoreDataManager;

// get a global context
+ (NSManagedObjectContext *)globalContext;

// save a context
+ (NSError *)saveContext:(NSManagedObjectContext *)context;

// insert a record to an existing table
+ (NSError *)insertARecordWithRecordValues:(NSDictionary *)values ToTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context;

// delete a record from an existing table
+ (NSError *)deleteARecord:(NSManagedObject *)record InContext:(NSManagedObjectContext *)context;

// update a record for a property (if the record exists) in an existing table
+ (NSError *)updateARecord:(NSManagedObject *)record WithNewRecordValues:(NSDictionary *)values InTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context;

// **************************	SEARCH TABLE	**************************

// fetch all records from a single table
+ (NSMutableArray *)fetchAllRecordsFromTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context;

// fetch all records sorted by certain attribute
+ (NSMutableArray *)fetchAllRecordsFromTable:(NSString *)tableName sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

// fetch records matched by a predicate
+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName MatchedByPredicate:(NSPredicate *)predicate InContext:(NSManagedObjectContext *)context;

// fetch records matched by a predicate, and sorted by certain attribute
+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName MatchedByPredicate:(NSPredicate *)predicate sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

// fetch records defined by the criteria in NSFetchRequest
+ (NSMutableArray *)fetchRecordsWithFetchRequest:(NSFetchRequest *)request InContext:(NSManagedObjectContext *)context;

// fetch records with a value for an attribute
+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName AttributeName:(NSString *)attribute AndValue:(id)value InContext:(NSManagedObjectContext *)context;

// fetch records with a value for an attribute, and sorted by certain attribute
+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName AttributeName:(NSString *)attribute AndValue:(id)value sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

// fetch the unique record with the given predicate
+ (id)fetchFirstRecordFromTable:(NSString *)tableName withPredicate:(NSPredicate *)predicate InContext:(NSManagedObjectContext *)context;

// fetch the first record with the given predicate, and sorted by certain attribute
+ (id)fetchFirstRecordFromTable:(NSString *)tableName withPredicate:(NSPredicate *)predicate sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context;

@end
