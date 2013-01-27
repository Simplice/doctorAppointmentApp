//
//  Patient.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 26.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Termin;

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSString * anrede;
@property (nonatomic, retain) NSString * nachname;
@property (nonatomic, retain) NSString * vorname;
@property (nonatomic, retain) Termin *termin;

@end
