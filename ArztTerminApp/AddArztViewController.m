//
//  AddArztViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 23.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "AddArztViewController.h"
#import "Validator.h"
#import "JSMCoreDataHelper.h"
#import "Arzt.h"
#import "ApplicationHelper.h"

@interface AddArztViewController ()

@end

@implementation AddArztViewController

@synthesize anrede = _anrede, vorname = _vorname, nachname = _nachname;
@synthesize selectedArzt = _selectedArzt;

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
    if (self.selectedArzt != nil) {
        self.anrede.text = self.selectedArzt.anrede;
        self.vorname.text = self.selectedArzt.vorname;
        self.nachname.text = self.selectedArzt.nachname;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -my own methods
- (IBAction)removeKeybord:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)saveNeuerArzt:(id)sender {
    //Validate: Eingabe Felder
    if(![Validator checkForNotEmptyPersonDateTextFields:self.anrede.text lastname:self.nachname.text firstname:self.vorname.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Alle Eingabefelder sind pflicht."];
        return;
    }
    // if the object arzt is nil, then a new arzt object will be created and persit
    if (self.selectedArzt == nil) {
        Arzt *arzt = [JSMCoreDataHelper insertManagedObjectOfClass:[Arzt class] inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
        arzt.anrede = self.anrede.text;
        arzt.vorname = self.vorname.text;
        arzt.nachname = self.nachname.text;
    }else {//the existing arzt object will be merged
        self.selectedArzt.anrede = self.anrede.text;
        self.selectedArzt.vorname = self.vorname.text;
        self.selectedArzt.nachname = self.nachname.text;
    }
    
    [JSMCoreDataHelper saveManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
