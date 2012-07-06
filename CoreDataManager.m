//
//  CoreDataManager.m
//
//  Created by Suraj on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@implementation CoreDataManager

#pragma mark - singleton

+ (CoreDataManager *)sharedCoreDataManager
{
	static dispatch_once_t pred; 
	static CoreDataManager *sharedCoreDataManager = nil; 
	dispatch_once(&pred, ^{ sharedCoreDataManager = [[self alloc] init]; }); 
	return sharedCoreDataManager; 
}

#pragma mark - context management

+ (NSManagedObjectContext *)globalContext
{
	return [[CoreDataManager sharedCoreDataManager] managedObjectContext];
}

- (NSManagedObjectContext *) managedObjectContext {
	
	if (managedObjectContext != nil) {
		return managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (coordinator != nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator: coordinator];
	}
	return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
	
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}
	// By default, it will search for and if not found, create a sqlite file named CoreData.sqlite
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CoreData.sqlite"];
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:@"CoreData" ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
		}
	}
	
	NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
	
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];	
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
	NSError *error;
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}    
	return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}

+ (NSError *)saveContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"cotext saving error!");
		return error;
	}
	return error;
}

#pragma mark - SQL Operations

+ (NSError *)insertARecordWithRecordValues:(NSDictionary*)values ToTable:(NSString *)tableName InContext:(NSManagedObjectContext*)context
{
	NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:tableName inManagedObjectContext:context];
	for(NSString *key in values.allKeys)
	{
		[entity setValue:[values valueForKey:key] forKey:key];
	}
	return [CoreDataManager saveContext:context];
}

+ (NSError *)deleteARecord:(NSManagedObject *)record InContext:(NSManagedObjectContext *)context
{
	[context deleteObject:record];
	return [CoreDataManager saveContext:context];
}

+ (NSError *)updateARecord:(NSManagedObject *)record WithNewRecordValues:(NSDictionary *)values InTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context
{
	for(NSString *key in values.allKeys)
	{
		[record setValue:[values valueForKey:key] forKey:key];
	}
	return [CoreDataManager saveContext:context];
}

+ (NSMutableArray *)fetchAllRecordsFromTable:(NSString *)tableName InContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	[request setEntity:entity];
	
	NSError *error = nil;
	return [[context executeFetchRequest:request error:&error] mutableCopy];

}

+ (NSMutableArray *)fetchAllRecordsFromTable:(NSString *)tableName sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	[request setEntity:entity];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error = nil;
	return [[context executeFetchRequest:request error:&error] mutableCopy];
}

+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName MatchedByPredicate:(NSPredicate *)predicate InContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	[request setEntity:entity];
	
	[request setPredicate:predicate];
	
	NSError *error = nil;
	return [[context executeFetchRequest:request error:&error] mutableCopy];
}

+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName MatchedByPredicate:(NSPredicate *)predicate sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	[request setEntity:entity];
	
	[request setPredicate:predicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error = nil;
	return [[context executeFetchRequest:request error:&error] mutableCopy];
}

+ (NSMutableArray *)fetchRecordsWithFetchRequest:(NSFetchRequest *)request InContext:(NSManagedObjectContext *)context
{
	NSError *error = nil;
	return [[context executeFetchRequest:request error:&error] mutableCopy];
}

+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName AttributeName:(NSString *)attribute AndValue:(id)value sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	[request setEntity:entity];
	
	[request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = %@",attribute,value]]];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:ascending];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptors release];
	[sortDescriptor release];
	
	NSError *error = nil;
	return [[context executeFetchRequest:request error:&error] mutableCopy];
}

+ (NSMutableArray *)fetchRecordsFromTable:(NSString *)tableName AttributeName:(NSString *)attribute AndValue:(id)value InContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	[request setEntity:entity];
	
	[request setPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ = %@",attribute,value]]];
	
	NSError *error = nil;
	return [[context executeFetchRequest:request error:&error] mutableCopy];

}

+ (NSManagedObject *)fetchFirstRecordFromTable:(NSString *)tableName withPredicate:(NSPredicate *)predicate InContext:(NSManagedObjectContext *)context
{
	NSMutableArray *allResults = [CoreDataManager fetchRecordsFromTable:tableName MatchedByPredicate:predicate InContext:context];
	if (allResults != nil) {
		return [allResults lastObject];
	}
	return nil;
}

+ (id)fetchFirstRecordFromTable:(NSString *)tableName withPredicate:(NSPredicate *)predicate sortedByAttribute:(NSString *)attributeName IsAscending:(BOOL)ascending InContext:(NSManagedObjectContext *)context
{
	NSMutableArray *allResults = [CoreDataManager fetchRecordsFromTable:tableName MatchedByPredicate:predicate sortedByAttribute:attributeName IsAscending:ascending InContext:context];
	if (allResults != nil) {
		return [allResults objectAtIndex:0];
	}
	return nil;
}


@end
