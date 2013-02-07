//
//  ApplicationHelper.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 25.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "ApplicationHelper.h"

@implementation ApplicationHelper

+(void) fehlermeldungAnzeigen:(NSString*) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FEHLER" message:message delegate:self cancelButtonTitle:@"Schliessen" otherButtonTitles: nil];
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


@end
