//
//  JSMCoreDataHelper.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 24.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JSMCoreDataHelper : NSObject

+(NSString *) directoryForDatabaseFilename;

+(NSManagedObjectContext *) managedObjectContext;

+(id) insertManagedObjectOfClass: (Class) aClass inManagedObjectContext: (NSManagedObjectContext *) managedContext;

+(BOOL) saveManagedObjectContext: (NSManagedObjectContext *) managedContext;

+(NSArray *) fetchEntitiesForClass: (Class) aClass withPredicate: (NSPredicate *) predicate sortedByEntityProperty: (NSString *) sortedProperty inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext;

+(BOOL) performFetchOnFetchedResultController: (NSFetchedResultsController *) fetchedResultsController;

+(NSPredicate*) filterPredicateForEntityAttribue: (NSString*) entityAttribute withSearchText: (NSString*) searchText;

@end
