//
//  Validator.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 25.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#define MAX_MIN_PER_DAY  60
#define MAX_HOUR_PER_DAY 24

#import "Validator.h"

@implementation Validator

+(BOOL) checkForNotEmptyPersonDateTextFields:(NSString*) anrede lastname:(NSString *) lastname firstname:(NSString *) vorname {
    if (anrede.length == 0 || lastname.length == 0 || vorname.length == 0) {
        return NO;
    }
    return YES;
}

+(BOOL) checkIfBeginHourBeforeEndHour: (NSString*) beginHour :(NSString *) endHour :(NSString*) beginMin :(NSString *) endMin {
    if ([beginHour intValue] == [endHour intValue]) {
        if ([beginMin intValue] >= [endMin intValue]) {
            return NO;
        }
    } else if ([beginHour intValue] > [endHour intValue]) {
        return NO;
    }
    return YES;
}

+(BOOL) checkForNotEmptyTextfields: (NSString*) beginHour :(NSString *) endHour :(NSString*) beginMin :(NSString *) endMin {
    if ((beginHour.length == 0) || (endHour.length == 0) || (beginMin.length == 0) || (endMin.length == 0)) {
        return NO;
    }
    return YES;
}

+(BOOL) checkForNegativeValue: (NSString*) beginHour :(NSString *) endHour :(NSString*) beginMin :(NSString *) endMin {
    if ([beginHour intValue] < 0 || [endHour intValue] < 0 || [beginMin intValue] < 0 || [endMin intValue] < 0) {
        return YES;
    }
    return NO;
}

+(BOOL) checkIfMinuteOverMaxMinute: (NSString*) beginMin :(NSString *) endMin {
    if ([beginMin intValue] > MAX_MIN_PER_DAY || [endMin intValue] > MAX_MIN_PER_DAY) {
        return YES;
    }
    return NO;
}

+(BOOL) checkIfHourOverMaxHour: (NSString*) beginHour :(NSString *) endHour {
    if ([beginHour intValue] > MAX_HOUR_PER_DAY || [endHour intValue] > MAX_HOUR_PER_DAY) {
        return YES;
    }
    return NO;
}

@end
