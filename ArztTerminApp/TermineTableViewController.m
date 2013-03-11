//
//  TermineTableViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 06.02.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "TermineTableViewController.h"
#import "JSMTableViewController.h"
#import "Zeitfenster.h"
#import "Patient.h"
#import "Termin.h"
#import "Arzt.h"
#import "JSMCoreDataHelper.h"
#import "Constants.h"

@interface TermineTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *termineFetchedResultsController;

@end

@implementation TermineTableViewController

@synthesize termineFetchedResultsController = _termineFetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [JSMCoreDataHelper performFetchOnFetchedResultController:self.fetchedResultsController];
}

#pragma mark - must be overrite by the subclass
-(NSFetchedResultsController *) fetchedResultsController {
    if (self.termineFetchedResultsController != nil) {
        return self.termineFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(Termin.class) inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    fetchRequest.entity = entityDescription;
    fetchRequest.predicate = self.searchFetchPredicate; // Use by the searcbar
    fetchRequest.fetchBatchSize = 64;
    
    NSSortDescriptor *sortDatum = [[NSSortDescriptor alloc] initWithKey:cEntityAttributeTerminDatum ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortDatum];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    self.termineFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[JSMCoreDataHelper managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.termineFetchedResultsController.delegate = self;
    
    return self.termineFetchedResultsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TermineIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // 1- Get each ROW. Configure the cell...
    Termin *termin = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // 2- Get Zeitfenster from the object Termin
    Zeitfenster *zeitfenster = [[termin.zeitfenster allObjects] objectAtIndex:0]; // TODO look the better way to fix it, insteak of using index 0

    // 3- Get Patient from the object Termin
    Patient *patient = [[termin.patient allObjects] objectAtIndex:0];// TODO look the better way to fix it, insteak of using index 0

    // 4- display data into the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"Patient/in: %@ %@ (Arzt: %@)", patient.vorname, patient.nachname, zeitfenster.arzt.nachname];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@", [self formatterToGermanDate:termin.datum],
                                 [NSString stringWithFormat:@"(%@:%@ - %@:%@)", zeitfenster.anfangStunde, zeitfenster.anfangMinunte, zeitfenster.endStunde, zeitfenster.endMinute]];
    //cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES]; 
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.isEditing;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[JSMCoreDataHelper managedObjectContext] deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}


-(void) barButtonItemEditPressed: (id) sender {
    [super barButtonItemEditPressed:sender];
    //Hide toolbar
    [self.navigationController setToolbarHidden:YES animated:NO];
}

-(NSString *) formatterToGermanDate: (NSDate *) entryDate {
    NSDateFormatter *dformat = [[NSDateFormatter alloc]init];
    [dformat setDateFormat:@"dd-MM-yyyy"];
    //[dformat setDateStyle:NSDateFormatterMediumStyle];
    return [dformat stringFromDate:entryDate];
}

#pragma mark - SearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [super searchBar:searchBar textDidChange:searchText];
    if (searchText.length > 0) {
        NSPredicate *filterPredicate = [JSMCoreDataHelper filterPredicateForEntityAttribue:cEntityAttributePatientNachname withSearchText:searchText];
        self.searchFetchPredicate = filterPredicate;
    } else {
        self.searchFetchPredicate = nil;
    }
    self.termineFetchedResultsController = nil;
    [JSMCoreDataHelper performFetchOnFetchedResultController:self.fetchedResultsController];
    [self.tableView reloadData];
}



@end
