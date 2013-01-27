//
//  Termin.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 23.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Patient, Zeitfenster;

@interface Termin : NSManagedObject

@property (nonatomic, retain) NSDate * datum;
@property (nonatomic, retain) NSSet *patient;
@property (nonatomic, retain) NSSet *zeitfenster;
@end

@interface Termin (CoreDataGeneratedAccessors)

- (void)addPatientObject:(Patient *)value;
- (void)removePatientObject:(Patient *)value;
- (void)addPatient:(NSSet *)values;
- (void)removePatient:(NSSet *)values;

- (void)addZeitfensterObject:(Zeitfenster *)value;
- (void)removeZeitfensterObject:(Zeitfenster *)value;
- (void)addZeitfenster:(NSSet *)values;
- (void)removeZeitfenster:(NSSet *)values;

@end
