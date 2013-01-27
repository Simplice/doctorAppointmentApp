//
//  Arzt.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 23.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Zeitfenster;

@interface Arzt : NSManagedObject

@property (nonatomic, retain) NSString * anrede;
@property (nonatomic, retain) NSString * vorname;
@property (nonatomic, retain) NSString * nachname;
@property (nonatomic, retain) NSSet *zeitfenster;
@end

@interface Arzt (CoreDataGeneratedAccessors)

- (void)addZeitfensterObject:(Zeitfenster *)value;
- (void)removeZeitfensterObject:(Zeitfenster *)value;
- (void)addZeitfenster:(NSSet *)values;
- (void)removeZeitfenster:(NSSet *)values;

@end
