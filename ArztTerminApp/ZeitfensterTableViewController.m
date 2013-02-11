//
//  ZeitfensterTableViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 26.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "ZeitfensterTableViewController.h"
#import "JSMCoreDataHelper.h"
#import "AddZeitfensterViewController.h"
#import "Constants.h"
#import "Arzt.h"
#import "Zeitfenster.h"

@interface ZeitfensterTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *zeitfensterFetchedResultsController;

@end

@implementation ZeitfensterTableViewController

@synthesize zeitfensterFetchedResultsController = _zeitfensterFetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
 
    [JSMCoreDataHelper performFetchOnFetchedResultController:self.fetchedResultsController];
}

#pragma mark - must be overrite by the subclass
-(NSFetchedResultsController *) fetchedResultsController {
    if (self.zeitfensterFetchedResultsController != nil) {
        return self.zeitfensterFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:cEntityZeitfenster inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    fetchRequest.entity = entityDescription;
    fetchRequest.predicate = self.searchFetchPredicate; // Use by the searcbar
    fetchRequest.fetchBatchSize = 64;
    
    NSSortDescriptor *sortVorname = [[NSSortDescriptor alloc] initWithKey:cEntityAttributeArztNachname ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortVorname];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    self.zeitfensterFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[JSMCoreDataHelper managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.zeitfensterFetchedResultsController.delegate = self;
    
    return self.zeitfensterFetchedResultsController;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ZeitfensterIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    Zeitfenster *zeitfenster = (Zeitfenster *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",zeitfenster.arzt.anrede, zeitfenster.arzt.nachname];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@h%@-%@h%@", zeitfenster.anfangStunde,zeitfenster.anfangMinunte,zeitfenster.endStunde,zeitfenster.endMinute];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES]; 
        
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showAddZeitfenster"] || [segue.identifier isEqualToString:@"showEditZeitfenster"]) {
        AddZeitfensterViewController *controller = [segue destinationViewController];
        controller.selectedZeitfenster = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}


#pragma mark - barButtonItems
-(void) barButtonItemAddPressed: (id) sender {
    [self performSegueWithIdentifier:@"showAddZeitfenster" sender:self];
}

#pragma mark - SearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [super searchBar:searchBar textDidChange:searchText];
    if (searchText.length > 0) {
        NSPredicate *filterPredicate = [JSMCoreDataHelper filterPredicateForEntityAttribue:cEntityAttributeArztNachname withSearchText:searchText];
        self.searchFetchPredicate = filterPredicate;
    } else {
        self.searchFetchPredicate = nil;
    }
    self.zeitfensterFetchedResultsController = nil;
    [JSMCoreDataHelper performFetchOnFetchedResultController:self.fetchedResultsController];
    [self.tableView reloadData];
}

@end
