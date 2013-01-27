//
//  Validator.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 25.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject

+(BOOL) checkIfBeginHourBeforeEndHour: (NSString*) beginHour :(NSString *) endHour :(NSString*) beginMin :(NSString *) endMin;

+(BOOL) checkForNotEmptyTextfields: (NSString*) beginHour :(NSString *) endHour :(NSString*) beginMin :(NSString *) endMin;

+(BOOL) checkForNegativeValue: (NSString*) beginHour :(NSString *) endHour :(NSString*) beginMin :(NSString *) endMin;

+(BOOL) checkIfMinuteOverMaxMinute: (NSString*) beginMin :(NSString *) endMin;

+(BOOL) checkIfHourOverMaxHour: (NSString*) beginHour :(NSString *) endHour;

+(BOOL) checkForNotEmptyPersonDateTextFields: (NSString*) anrede lastname:(NSString *) lastname firstname:(NSString *) vorname;

@end
