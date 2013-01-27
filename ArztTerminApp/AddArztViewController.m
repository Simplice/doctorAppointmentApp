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
    
    // ajouter une image au backgroungColor
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"320-fond.jpg"]];
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
    
    Arzt *arzt = [JSMCoreDataHelper insertManagedObjectOfClass:[Arzt class] inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    arzt.anrede = self.anrede.text;
    arzt.vorname = self.vorname.text;
    arzt.nachname = self.nachname.text;
    
    [JSMCoreDataHelper saveManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
