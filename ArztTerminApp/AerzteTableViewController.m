//
//  AerzteTableViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 22.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "AerzteTableViewController.h"
#import "AddArztViewController.h"
#import "JSMCoreDataHelper.h"
#import "Constants.h"
#import "Arzt.h"

@interface AerzteTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *arztFetchedResultsController;

@end

@implementation AerzteTableViewController

@synthesize arztFetchedResultsController = _arztFetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [JSMCoreDataHelper performFetchOnFetchedResultController:self.fetchedResultsController];
}

#pragma mark - must be overrite by the subclass
-(NSFetchedResultsController *) fetchedResultsController {
    if (self.arztFetchedResultsController != nil) {
        return self.arztFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(Arzt.class) inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    fetchRequest.entity = entityDescription;
    fetchRequest.predicate = self.searchFetchPredicate; // Use by the searcbar
    fetchRequest.fetchBatchSize = 64;

    NSSortDescriptor *sortVorname = [[NSSortDescriptor alloc] initWithKey:cEntityAttributeVorname ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortVorname];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    self.arztFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:[JSMCoreDataHelper managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.arztFetchedResultsController.delegate = self;
    
    return self.arztFetchedResultsController;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ArztIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // 1- Get each ROW of tableAllMovies. Configure the cell...
    Arzt *arzt = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // 2- display data into the cell.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", arzt.vorname, arzt.nachname];
    cell.detailTextLabel.text = arzt.anrede;
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

// This method is used to edit the arzt entity
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showAddArzt" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showAddArzt"]) {
        AddArztViewController *addArztViewController = [segue destinationViewController];
        addArztViewController.selectedArzt = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

#pragma mark - barButtonItems

-(void) barButtonItemAddPressed: (id) sender {
    [self performSegueWithIdentifier:@"showAddArzt" sender:self];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [super searchBar:searchBar textDidChange:searchText];
    if (searchText.length > 0) {
        NSPredicate *filterPredicate = [JSMCoreDataHelper filterPredicateForEntityAttribue:cEntityAttributeNachname withSearchText:searchText];
        self.searchFetchPredicate = filterPredicate;
    } else {
        self.searchFetchPredicate = nil;
    }
    self.arztFetchedResultsController = nil;
    [JSMCoreDataHelper performFetchOnFetchedResultController:self.fetchedResultsController];
    [self.tableView reloadData];
}


@end
