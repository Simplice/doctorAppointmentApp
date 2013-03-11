//
//  AddZeitfensterViewController.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 25.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Zeitfenster;

@interface AddZeitfensterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *beginHour;
@property (strong, nonatomic) IBOutlet UITextField *beginMin;
@property (strong, nonatomic) IBOutlet UITextField *endHour;
@property (strong, nonatomic) IBOutlet UITextField *endMin;
@property (strong, nonatomic) IBOutlet UITextField *ganzerName;
@property (strong, nonatomic) IBOutlet UILabel *displayDatumAsText;
@property (nonatomic, strong) NSDate *storedDatum;

@property (strong, nonatomic) IBOutlet Zeitfenster *selectedZeitfenster;

- (IBAction)saveZeitfenster:(id)sender;

- (IBAction) startMethodToCheckMaxLength: (id) sender;
- (IBAction) stopMethodToCheckMaxLength: (id) sender;
@end
