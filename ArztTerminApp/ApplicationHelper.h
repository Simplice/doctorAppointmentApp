//
//  ApplicationHelper.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 25.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationHelper : NSObject

+(void) alertMeldungAnzeigen:(NSString*) message mitTitle: (NSString*) title;

+(NSDate *) createDateComponentWithDay: (NSString*) day andWithMonth: (NSString*) month andWithYear: (NSString*) year;

+(NSArray *) extrahiereDayMonthYearFromDate: (NSDate*) date;

+(NSString *) displayDateObjectAlsString: (NSDate*) date;

+(NSDate *) determineDateWithoutTime: (NSDate *) date;

@end
