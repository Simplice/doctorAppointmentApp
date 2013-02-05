//
//  AddZeitfensterViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 25.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "AddZeitfensterViewController.h"
#import "Validator.h"
#import "JSMCoreDataHelper.h"
#import "Arzt.h"
#import "Zeitfenster.h"
#import "ApplicationHelper.h"

@interface AddZeitfensterViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) Arzt *gefundenerArzt;

@end

@implementation AddZeitfensterViewController

@synthesize beginHour = _beginHour, beginMin = _beginMin, endHour = _endHour, endMin = _endMin, ganzerName = _ganzerName;
@synthesize timer = _timer, currentTextField = _currentTextField, gefundenerArzt = _gefundenerArzt;

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

#pragma mark -my own methods
- (IBAction)removeKeybord:(id)sender {
    [self resignFirstResponder];
}

- (IBAction) startMethodToCheckMaxLength: (id) sender {
    self.currentTextField = sender;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkMaxLengthTextField) userInfo:nil repeats:YES];
}

- (IBAction) stopMethodToCheckMaxLength: (id) sender {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void) checkMaxLengthTextField {
    if ([self.currentTextField text].length > 2) {
        self.currentTextField.text = [self.currentTextField.text substringWithRange:NSMakeRange(0, 2)];
    }
}

- (IBAction)saveZeitfenster:(id)sender {
    [self resignFirstResponder];
    
    // Validate: check if empty textfield exist
    if(![Validator checkForNotEmptyTextfields:self.beginHour.text :self.endHour.text :self.beginMin.text :self.endMin.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Alle Eingabefelder sind pflicht."];
        return;
    }
    
    // Validate: check if negativ value exist
    if ([Validator checkForNegativeValue:self.beginHour.text :self.endHour.text :self.beginMin.text :self.endMin.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Kein negativer Wert darf eingegeben werden."];
        return;
    }
    
    // Validate: check if Minute is over MAX_MIN=60
    if([Validator checkIfMinuteOverMaxMinute:self.beginMin.text :self.endMin.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Bitte korrigieren Sie die Minuteneingaben (Min. zw. 0 und 59)."];
        return;
    }
    
    // Validate: check if Hour is over MAX_HOUR=24
    if([Validator checkIfHourOverMaxHour:self.beginHour.text :self.endHour.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Bitte korrigieren Sie die Stundeneingaben (Min. zw. 0 und 23)."];
        return;
    }
    
    // Validate: check if begin-time bigger than end time
    if(![Validator checkIfBeginHourBeforeEndHour:self.beginHour.text :self.endHour.text :self.beginMin.text :self.endMin.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Startuhrzeit muss nicht größer als Enduhrzeit sein."];
        return;
    }
    
    //check and load Arzt if he exists
    if(![self ladenArztMitEingegebenemNamen:self.ganzerName.text inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Bitte überprüfen Sie die eingegebenen Daten."];
        return;
    }
    
    // save the new Object into the database
    Zeitfenster *zeitfenster = [JSMCoreDataHelper insertManagedObjectOfClass:[Zeitfenster class] inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    [zeitfenster setAnfangStunde:[NSNumber numberWithInt:[self.beginHour.text intValue]]];
    [zeitfenster setAnfangMinunte:[NSNumber numberWithInt:[self.beginMin.text intValue]]];
    [zeitfenster setEndStunde:[NSNumber numberWithInt:[self.endHour.text intValue]]];
    [zeitfenster setEndMinute:[NSNumber numberWithInt:[self.endMin.text intValue]]];
    [zeitfenster setArzt:self.gefundenerArzt];
    
    [JSMCoreDataHelper saveManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    NSLog(@"Das Zeitfenster wurde erfolgreich gespeichert");
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(BOOL) ladenArztMitEingegebenemNamen: (NSString *) ganzerName inManagedObjectContext: (NSManagedObjectContext *) managedContext {
    //predicate um nach einem Arzt zu suchen bzw. filtern
    NSArray * items = [ganzerName componentsSeparatedByString:@","];
    if (ganzerName.length != 0 && [items count] == 2) {
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                                  [NSArray arrayWithObjects:
                                   [NSPredicate predicateWithFormat:@"nachname == %@", [items[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]],
                                   [NSPredicate predicateWithFormat:@"vorname == %@", [items[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]], nil]];
        
        // then use the ManagedObjectContext to search for the Arzt
        NSArray *result = [JSMCoreDataHelper fetchEntitiesForClass:[Arzt class] withPredicate:predicate sortedByEntityProperty:nil  inManagedObjectContext:managedContext];
        if (result && [result count] > 0) {
            Arzt *gefundenerArzt = result[0]; // hier geben wir zurück der erste Arzt in der Liste
            self.gefundenerArzt = gefundenerArzt;
            return YES; // Arzt wurde gefunden.
        }
    }
    return NO;
}

@end
