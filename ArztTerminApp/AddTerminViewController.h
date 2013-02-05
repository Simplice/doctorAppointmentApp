//
//  AddTerminViewController.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 27.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTerminViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *terminDatum;
@property (strong, nonatomic) IBOutlet UITextField *vollerNamePatient;
@property (strong, nonatomic) IBOutlet UITextField *terminBegin;
@property (strong, nonatomic) IBOutlet UITextField *terminEnd;

- (IBAction)removeKeybord:(id)sender ;

- (IBAction)saveTermin:(id)sender ;

@end
