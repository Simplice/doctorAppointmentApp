//
//  AddPatientViewController.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 23.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;

@interface AddPatientViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *anrede;
@property (strong, nonatomic) IBOutlet UITextField *nachname;
@property (strong, nonatomic) IBOutlet UITextField *vorname;

@property (nonatomic, strong) Patient *selectedPatient;

- (IBAction)removeKeybord:(id)sender;

- (IBAction)saveNeuerPatient:(id)sender;

@end
