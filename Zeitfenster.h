//
//  Zeitfenster.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 08.03.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Arzt, Termin;

@interface Zeitfenster : NSManagedObject

@property (nonatomic, retain) NSNumber * anfangMinunte;
@property (nonatomic, retain) NSNumber * anfangStunde;
@property (nonatomic, retain) NSNumber * endMinute;
@property (nonatomic, retain) NSNumber * endStunde;
@property (nonatomic, retain) NSDate * datum;
@property (nonatomic, retain) Arzt *arzt;
@property (nonatomic, retain) Termin *termin;

@end
