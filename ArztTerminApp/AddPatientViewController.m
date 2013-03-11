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
@synthesize selectedPatient = _selectedPatient;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// ajouter une image au backgroungColor
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"320-fond.jpg"]];
    
    if (self.selectedPatient != nil) {
        self.anrede.text = self.selectedPatient.anrede;
        self.vorname.text = self.selectedPatient.vorname;
        self.nachname.text = self.selectedPatient.nachname;
    }
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
        [ApplicationHelper alertMeldungAnzeigen:@"Alle Eingabefelder sind pflicht." mitTitle:@"FEHLER"];
        return;
    }
    
    if(self.selectedPatient == nil) { // Persist new entity object
        Patient *patient = [JSMCoreDataHelper insertManagedObjectOfClass:[Patient class] inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
        patient.anrede = self.anrede.text;
        patient.vorname = self.vorname.text;
        patient.nachname = self.nachname.text;
    }else { // merged existing entity object
        self.selectedPatient.anrede = self.anrede.text;
        self.selectedPatient.vorname = self.vorname.text;
        self.selectedPatient.nachname = self.nachname.text;
    }
    
    [JSMCoreDataHelper saveManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
