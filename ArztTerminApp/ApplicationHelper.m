//
//  ApplicationHelper.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 25.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "ApplicationHelper.h"

@implementation ApplicationHelper

+(void) alertMeldungAnzeigen:(NSString*) message mitTitle: (NSString*) title{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Schliessen" otherButtonTitles: nil];
    if ([title caseInsensitiveCompare:@"FEHLER"] == NSOrderedSame) {
        [alert setBackgroundColor:[UIColor redColor]];
    }
    [alert show];
}

+(NSDate *) createDateComponentWithDay: (NSString*) day andWithMonth: (NSString*) month andWithYear: (NSString*) year {
    // using the objet NSDateComponents and NSCalendar
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init]; //
    [dformat setDateFormat:@"yyyy-MM-dd"];
    //[dformat setDateStyle:NSDateFormatterMediumStyle];
    NSDateComponents *nsDateComp = [[NSDateComponents alloc] init];
    [nsDateComp setYear:[year intValue]];
    [nsDateComp setMonth:[month intValue]];
    [nsDateComp setDay:[day intValue]];
    return [[NSCalendar currentCalendar] dateFromComponents:nsDateComp];
}

+(NSArray *) extrahiereDayMonthYearFromDate: (NSDate*) date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSArray *arrays = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%i",[components day]],[NSString stringWithFormat:@"%i",[components month]],[NSString stringWithFormat:@"%i",[components year]], nil];
    return arrays;
}

+(NSString *) displayDateObjectAlsString: (NSDate*) date {
    NSString *result;
    // 1. Set Location (the selected date with be displayed with german format)
    //NSLocale *deLocate = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init]; //
    [dformat setDateFormat:@"dd-MM-yyyy"];
    result = [dformat stringFromDate:date];
    return result;
}

+(NSDate *) determineDateWithoutTime: (NSDate *) date {
    NSCalendar* myCalendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [myCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                 fromDate:date];
    [components setHour: 23];
    [components setMinute: 0];
    [components setSecond: 0];
    return[myCalendar dateFromComponents:components];
}


@end
