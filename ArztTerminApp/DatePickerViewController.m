//
//  DatePickerViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 08.03.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AddZeitfensterViewController.h"
#import "Zeitfenster.h"
#import "Validator.h"
#import "ApplicationHelper.h"

@interface DatePickerViewController ()
@property (nonatomic, strong) NSDate *storedDate;
@end

@implementation DatePickerViewController

@synthesize zeitfensterViewController = _zeitfensterViewController,
    showSelectedDatum = _showSelectedDatum, datePicker = _datePicker, storedDate = _storedDate;

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
    if([self.zeitfensterViewController storedDatum] != nil) {
        NSDate *tmpDate = self.zeitfensterViewController.storedDatum;
        // 1 set DATEPICKER with the current date
        [self.datePicker setDate:tmpDate animated:YES];
        // 2 Display de Current date als Text
        self.showSelectedDatum.text = [ApplicationHelper displayDateObjectAlsString:tmpDate];
    } else {
        // Set property showSelectedDatum with today
        NSDate *today =[NSDate date];
        self.storedDate = today;
        self.showSelectedDatum.text = [ApplicationHelper displayDateObjectAlsString:today];
    }
    
    [self.datePicker addTarget:self action:@selector(dateHasChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

-(void) dateHasChanged: (id) sender {
    // 1. get the date displayed by the datePicker
    NSDate *pickerDate = [self.datePicker date];
    self.storedDate = pickerDate;
    // 2. set the Label with pickerDate as String
    self.showSelectedDatum.text = [ApplicationHelper displayDateObjectAlsString:pickerDate];
}

- (IBAction)datumUebernehmen:(id)sender {
    if([Validator checkIfDateInThePass:self.storedDate]) {
        [ApplicationHelper alertMeldungAnzeigen:@"Das Datum darf nicht in der Vergangenheit liegen" mitTitle:@"FEHLER"];
        return;
    }

    self.zeitfensterViewController.storedDatum = self.storedDate;
    self.zeitfensterViewController.displayDatumAsText.text = [ApplicationHelper displayDateObjectAlsString:self.storedDate];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)datumZuruecksetzten:(id)sender {
    [self.datePicker setDate:[NSDate date] animated:YES];
    self.zeitfensterViewController.displayDatumAsText.text = @"Datum auszuwählen.";
    [self dateHasChanged:sender];
}
@end
