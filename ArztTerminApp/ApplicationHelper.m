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

@end
