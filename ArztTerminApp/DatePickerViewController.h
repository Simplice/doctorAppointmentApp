//
//  DatePickerViewController.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 08.03.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddZeitfensterViewController.h"


@interface DatePickerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) AddZeitfensterViewController *zeitfensterViewController;
@property (strong, nonatomic) IBOutlet UILabel *showSelectedDatum;

- (IBAction)datumUebernehmen:(id)sender;
- (IBAction)datumZuruecksetzten:(id)sender;

@end
