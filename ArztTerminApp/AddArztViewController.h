//
//  AddArztViewController.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 23.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Arzt;

@interface AddArztViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITextField *anrede;
@property (strong, nonatomic) IBOutlet UITextField *nachname;
@property (strong, nonatomic) IBOutlet UITextField *vorname;

@property (nonatomic, strong) Arzt *selectedArzt;

- (IBAction)removeKeybord:(id)sender;

- (IBAction)saveNeuerArzt:(id)sender;

@end
