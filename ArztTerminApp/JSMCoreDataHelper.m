//
//  JSMCoreDataHelper.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 24.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "JSMCoreDataHelper.h"
#import "Constants.h"

@implementation JSMCoreDataHelper

+(NSString *) directoryForDatabaseFilename {
    return [NSHomeDirectory() stringByAppendingString:@"/Library/Private Documents"];
}

+(NSManagedObjectContext *) managedObjectContext {
    
    static NSManagedObjectContext *managedObjectContext;
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:[JSMCoreDataHelper directoryForDatabaseFilename] withIntermediateDirectories:YES attributes:nil error:&error];
    
    if(error) {
        NSLog(@"Fehler: %@", [error localizedDescription]);
        return nil;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [JSMCoreDataHelper directoryForDatabaseFilename], cDatabaseFilename];
    
    NSURL *url  = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *managedModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedModel];
    
    if(![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"Fehler: %@", [error localizedDescription]);
        return nil;
    }
    
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    managedObjectContext.persistentStoreCoordinator = storeCoordinator;
    return managedObjectContext;
}

+(id) insertManagedObjectOfClass: (Class) aClass inManagedObjectContext: (NSManagedObjectContext *) managedContext {
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(aClass) inManagedObjectContext:managedContext];
    return managedObject;
}

/**
    Hier wird die Daten in der DB-SQLITE gespeichert
 */
+(BOOL) saveManagedObjectContext: (NSManagedObjectContext *) managedContext {
    NSError *error;
    if (![managedContext save:&error]) {
        NSLog(@"Fehler: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

/**
 Hier wird die Daten in der DB-SQLITE geladen
 */
+(NSArray *) fetchEntitiesForClass: (Class) aClass withPredicate: (NSPredicate *) predicate sortedByEntityProperty: (NSString *) sortedProperty inManagedObjectContext: (NSManagedObjectContext *) managedObjectContext {
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Sortierung nach dem eingegebene Property
    if (sortedProperty != nil && ![sortedProperty isEqualToString:@""]) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortedProperty ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(aClass) inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error) {
        NSLog(@"Fehler: %@", [error localizedDescription]);
        return nil;
    }
    return items;
}

+(BOOL) performFetchOnFetchedResultController: (NSFetchedResultsController *) fetchedResultsController {
    NSError *error;
    if(![fetchedResultsController performFetch:&error]) {
        NSLog(@"Fehler: %@", [error localizedDescription]);
        return NO;
    }
    return YES;
}

+(NSPredicate*) filterPredicateForEntityAttribue: (NSString*) entityAttribute withSearchText: (NSString*) searchText {
    return [NSPredicate predicateWithFormat:@"%K contains[c] %@", entityAttribute, searchText];
}


@end
