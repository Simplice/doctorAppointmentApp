//
//  AddTerminViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 27.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "AddTerminViewController.h"
#import "Validator.h"
#import "ApplicationHelper.h"

@interface AddTerminViewController ()

@end

@implementation AddTerminViewController

@synthesize terminBegin = _terminBegin, terminEnd = _terminEnd,
    terminDatum = _terminDatum, vollerNamePatient = _vollerNamePatient;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -my own methods
- (IBAction)removeKeybord:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)saveTermin:(id)sender {
    if (![Validator checkForValidDate:self.terminDatum.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Bitte korrigieren Sie das Datum."];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
