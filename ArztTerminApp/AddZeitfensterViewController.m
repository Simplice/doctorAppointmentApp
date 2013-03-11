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
#import "DatePickerViewController.h"

@interface AddZeitfensterViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) Arzt *gefundenerArzt;
@property (nonatomic, assign) BOOL datenUeberschneidenSich;

@end

@implementation AddZeitfensterViewController

@synthesize beginHour = _beginHour, beginMin = _beginMin, endHour = _endHour, endMin = _endMin, ganzerName = _ganzerName;
@synthesize timer = _timer, currentTextField = _currentTextField, gefundenerArzt = _gefundenerArzt, displayDatumAsText = _displayDatumAsText;
@synthesize selectedZeitfenster = _selectedZeitfenster, storedDatum = _storedDatum, datenUeberschneidenSich = _datenUeberschneidenSich;

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
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    // ajouter une image au backgroungColor
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"320-fond.jpg"]];
    
    if (self.selectedZeitfenster != nil) {
        self.beginHour.text = [NSString stringWithFormat:@"%@", self.selectedZeitfenster.anfangStunde];
        self.beginMin.text = [NSString stringWithFormat:@"%@", self.selectedZeitfenster.anfangMinunte];
        self.endHour.text = [NSString stringWithFormat:@"%@", self.selectedZeitfenster.endStunde];
        self.endMin.text = [NSString stringWithFormat:@"%@", self.selectedZeitfenster.endMinute];
        self.displayDatumAsText.text = [ApplicationHelper displayDateObjectAlsString:self.selectedZeitfenster.datum];
        self.storedDatum = self.selectedZeitfenster.datum;
        self.ganzerName.text = [NSString stringWithFormat:@"%@, %@", self.selectedZeitfenster.arzt.nachname, self.selectedZeitfenster.arzt.vorname];
        [self.ganzerName setEnabled:NO]; // Disable the Field
    }
    
    // 2 Add a tap gesture recognizer to the view, so that if the keyboard is displayed, tapping anywhere outside of an input object will call the hideKeyboard method to dismiss the keyboard.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDatePicker"]) {
        DatePickerViewController *controller = [segue destinationViewController];
        controller.zeitfensterViewController = self;
    }
}

#pragma mark -my private methods
- (IBAction)removeKeybord:(id)sender {
    [self resignFirstResponder];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
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
        [ApplicationHelper alertMeldungAnzeigen:@"Alle Eingabefelder sind pflicht." mitTitle:@"FEHLER"];
        return;
    }
    
    // Validate: check if negativ value exist
    if ([Validator checkForNegativeValue:self.beginHour.text :self.endHour.text :self.beginMin.text :self.endMin.text]) {
        [ApplicationHelper alertMeldungAnzeigen:@"Kein negativer Wert darf eingegeben werden." mitTitle:@"FEHLER"];
        return;
    }
    
    // Validate: check if Minute is over MAX_MIN=60
    if([Validator checkIfMinuteOverMaxMinute:self.beginMin.text :self.endMin.text]) {
        [ApplicationHelper alertMeldungAnzeigen:@"Bitte korrigieren Sie die Minuteneingaben (Min. zw. 0 und 59)." mitTitle:@"FEHLER"];
        return;
    }
    
    // Validate: check if Hour is over MAX_HOUR=24
    if([Validator checkIfHourOverMaxHour:self.beginHour.text :self.endHour.text]) {
        [ApplicationHelper alertMeldungAnzeigen:@"Bitte korrigieren Sie die Stundeneingaben (Min. zw. 0 und 23)." mitTitle:@"FEHLER"];
        return;
    }
    
    // Validate: check if begin-time bigger than end time
    if(![Validator checkIfBeginHourBeforeEndHour:self.beginHour.text :self.endHour.text :self.beginMin.text :self.endMin.text]) {
        [ApplicationHelper alertMeldungAnzeigen:@"Startuhrzeit muss nicht größer als Enduhrzeit sein." mitTitle:@"FEHLER"];
        return;
    }
    // Validate: check if termin-Datum is not empty
    if(self.storedDatum == nil) {
        [ApplicationHelper alertMeldungAnzeigen:@"Bitte wählen Sie ein Datum ein." mitTitle:@"FEHLER"];
        return;
    }
    //check and load Arzt if he exists
    if(![self ladenArztMitEingegebenemNamen:self.ganzerName.text inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]]) {
        [ApplicationHelper alertMeldungAnzeigen:@"Bitte überprüfen Sie die eingegebenen Daten." mitTitle:@"FEHLER"];
        return;
    }
    
    if ([self pruefeZeitfensterSichUeberschneidenMitgespeicherteZeitfenster:self.gefundenerArzt.zeitfenster]) {
        [ApplicationHelper alertMeldungAnzeigen:@"Das eingegebene Zeitfenster überschneiden sich mit dem schon gespeicherten Zeitfenster des Arztes." mitTitle:@"FEHLER"];
        return;
    }
    
    // save the new Object into the database
    if (self.selectedZeitfenster == nil) {
        Zeitfenster *zeitfenster = [JSMCoreDataHelper insertManagedObjectOfClass:[Zeitfenster class] inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
        [zeitfenster setAnfangStunde:[NSNumber numberWithInt:[self.beginHour.text intValue]]];
        [zeitfenster setAnfangMinunte:[NSNumber numberWithInt:[self.beginMin.text intValue]]];
        [zeitfenster setEndStunde:[NSNumber numberWithInt:[self.endHour.text intValue]]];
        [zeitfenster setEndMinute:[NSNumber numberWithInt:[self.endMin.text intValue]]];
        [zeitfenster setDatum:self.storedDatum];
        [zeitfenster setArzt:self.gefundenerArzt];
    } else {
        self.selectedZeitfenster.anfangStunde = [NSNumber numberWithInt:[self.beginHour.text intValue]];
        self.selectedZeitfenster.anfangMinunte = [NSNumber numberWithInt:[self.beginMin.text intValue]];
        self.selectedZeitfenster.endStunde = [NSNumber numberWithInt:[self.endHour.text intValue]];
        self.selectedZeitfenster.endMinute = [NSNumber numberWithInt:[self.endMin.text intValue]];
        self.selectedZeitfenster.datum = self.storedDatum;
        // Arztname braucht nicht überschrieben werden, weil das Feld readonly angezeigt wird.
    }
    
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

-(BOOL) pruefeZeitfensterSichUeberschneidenMitgespeicherteZeitfenster: (NSSet *) listeZeitfenster {
    self.datenUeberschneidenSich = NO;
    [listeZeitfenster enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        Zeitfenster *tmp = (Zeitfenster *)obj;

        if ([[ApplicationHelper determineDateWithoutTime:tmp.datum] compare:[ApplicationHelper determineDateWithoutTime:self.storedDatum]] == NSOrderedSame) {
            if(tmp.endStunde.intValue > self.beginHour.text.intValue ||
               (tmp.endStunde.intValue == self.beginHour.text.intValue && tmp.endMinute.intValue > self.beginMin.text.intValue)) {
                self.datenUeberschneidenSich = YES;
                *stop = YES;
            }
        }
    }];
    return self.datenUeberschneidenSich;
}

@end
