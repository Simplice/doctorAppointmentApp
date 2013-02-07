//
//  AddStaticTableViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 06.02.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "AddStaticTableViewController.h"
#import "Zeitfenster.h"
#import "Patient.h"
#import "Termin.h"
#import "Arzt.h"
#import "Validator.h"
#import "ApplicationHelper.h"
#import "JSMCoreDataHelper.h"


@interface AddStaticTableViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) Patient *gefundenerPatient;

@end

@implementation AddStaticTableViewController

@synthesize arztname = _arztname, beginTermin = _beginTermin, endTermin = _endTermin, currentTextField = _currentTextField;
@synthesize selectedZeitfenster = _selectedZeitfenster, timer = _timer, vollerNamePatient = _vollerNamePatient;
@synthesize gefundenerPatient = _gefundenerPatient;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.selectedZeitfenster != nil) {
        self.arztname.text =  [NSString stringWithFormat:@"%@ %@", self.selectedZeitfenster.arzt.vorname, self.selectedZeitfenster.arzt.nachname];
        self.beginTermin.text = [NSString stringWithFormat:@"%@:%@", self.selectedZeitfenster.anfangStunde, self.selectedZeitfenster.anfangMinunte];
        self.endTermin.text = [NSString stringWithFormat:@"%@:%@", self.selectedZeitfenster.endStunde, self.selectedZeitfenster.endMinute];
    }
    // wenn das selectierte Zeitfenster schon ein Termin hat, dann wird dieser angezeigt
    if (self.selectedZeitfenster.termin != nil) {
        NSArray *items = [ApplicationHelper extrahiereDayMonthYearFromDate:self.selectedZeitfenster.termin.datum];
        Patient *patient = [[self.selectedZeitfenster.termin.patient allObjects] objectAtIndex:0]; // TODO look the better way to fix it, insteak of using index 0
        self.vollerNamePatient.text = [NSString stringWithFormat:@"%@, %@", patient.nachname, patient.vorname];
        self.tag.text = [items objectAtIndex:0];
        self.monat.text = [items objectAtIndex:1];
        self.jahr.text = [items objectAtIndex:2];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -my own methods
- (IBAction)removeKeybord:(id)sender {
    [self resignFirstResponder];
}

- (IBAction)saveTermin:(id)sender {
    [self removeKeybord:sender];
    
    if (self.tag.text.length == 0 || self.monat.text.length == 0 || self.jahr.text.length == 0 || self.vollerNamePatient.text.length == 0) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Alle Felder sind Pflicht."];
        return;
    }
    // hier wird geprüft, ob dass Monat größer als 12 ist
    if ([self.monat.text intValue] > 12) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Die Monateingabe muss zwischen 1 bis 12 liegen."];
        return;
    }
    // hier wird geprüft, ob dass Jahr 4 Ziffer hat
    if (self.jahr.text.length != 4) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Das eingegebene Jahr muss 4 Ziffer sein."];
        return;
    }    
    if([Validator checkIfDateInThePassWithDay:self.tag.text andWithMonth:self.monat.text andWithYear:self.jahr.text]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Das Datum darf nicht in der Vergangenheit liegen"];
        return;
    }
    
    //prüfe ob Patient existiert, sonst Fehlermeldung raus werfen
    if (![self ladenPatientMitEingegebenemNamen:self.vollerNamePatient.text inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]]) {
        [ApplicationHelper fehlermeldungAnzeigen:@"Der eingegebene Patientname wurde nicht gefunden."];
        return;
    }
    
    // Neuer Termin eintragen wenn Termin nil ist (PERSIST)
    if (self.selectedZeitfenster.termin == nil) {
        Termin *termin = [JSMCoreDataHelper insertManagedObjectOfClass:[Termin class] inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
        termin.zeitfenster = [NSSet setWithObject:self.selectedZeitfenster];
        termin.patient = [NSSet setWithObject:self.gefundenerPatient];
        termin.datum = [ApplicationHelper createDateComponentWithDay:self.tag.text andWithMonth:self.monat.text andWithYear:self.jahr.text];
    }else { // MERGED
        // prüfe ob der Patientname geändert wurde, wenn ja dann nach dem neuen Patienten suche
        if (![self ladenPatientMitEingegebenemNamen:self.vollerNamePatient.text inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]]) {
            [ApplicationHelper fehlermeldungAnzeigen:@"Der eingegebene Patientname wurde nicht gefunden."];
            return;
        }
        [self.selectedZeitfenster.termin setDatum:[ApplicationHelper createDateComponentWithDay:self.tag.text
                                                                                   andWithMonth:self.monat.text andWithYear:self.jahr.text]];
        [self.selectedZeitfenster.termin.patient setByAddingObject:self.gefundenerPatient];
    }
    
    [JSMCoreDataHelper saveManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    
    
    NSLog(@"size of the set object ist : %i", [self.selectedZeitfenster.termin.patient count]);
    
    [self.navigationController popViewControllerAnimated:YES];
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

-(BOOL) ladenPatientMitEingegebenemNamen: (NSString *) ganzerName inManagedObjectContext: (NSManagedObjectContext *) managedContext {
    //predicate um nach einem Arzt zu suchen bzw. filtern
    NSArray * items = [ganzerName componentsSeparatedByString:@","];
    if (ganzerName.length != 0 && [items count] == 2) {
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                                  [NSArray arrayWithObjects:
                                   [NSPredicate predicateWithFormat:@"nachname == %@", [items[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]],
                                   [NSPredicate predicateWithFormat:@"vorname == %@", [items[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]], nil]];
        
        // then use the ManagedObjectContext to search for the Arzt
        NSArray *result = [JSMCoreDataHelper fetchEntitiesForClass:[Patient class] withPredicate:predicate sortedByEntityProperty:nil  inManagedObjectContext:managedContext];
        if (result && [result count] > 0) {
            Patient *patient = result[0]; // hier geben wir zurück der erste Patient in der Liste
            self.gefundenerPatient = patient;
            return YES; // Arzt wurde gefunden.
        }
    }
    return NO;
}

@end
