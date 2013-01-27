//
//  AddPatientViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 23.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "AddPatientViewController.h"
#import "Validator.h"
#import "JSMCoreDataHelper.h"
#import "ApplicationHelper.h"
#import "Patient.h"

@interface AddPatientViewController ()

@end

@implementation AddPatientViewController

@synthesize anrede = _anrede, vorname = _vorname, nachname = _nachname;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // ajouter une image au backgroungColor
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"320-fond.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my own methods
- (IBAction)removeKeybord:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)saveNeuerPatient:(id)sender {
    //Validate: Eingabe Felder
    if(![Validator checkForNotEmptyPersonDateTextFields:self.anrede.text lastname:self.nachname.text firstname:self.vorname.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Alle Eingabefelder sind pflicht."];
        return;
    }

    Patient *patient = [JSMCoreDataHelper insertManagedObjectOfClass:[Patient class] inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    patient.anrede = self.anrede.text;
    patient.vorname = self.vorname.text;
    patient.nachname = self.nachname.text;
    
    [JSMCoreDataHelper saveManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
