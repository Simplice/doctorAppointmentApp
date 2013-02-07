//
//  ZeitfensterWaehlenTableViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 06.02.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "ZeitfensterWaehlenTableViewController.h"
#import "AddStaticTableViewController.h"
#import "Zeitfenster.h"
#import "JSMCoreDataHelper.h"
#import "Zeitfenster.h"
#import "Arzt.h"
#import "Constants.h"

@interface ZeitfensterWaehlenTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *zfFetchedResultsController;

@end

@implementation ZeitfensterWaehlenTableViewController

@synthesize zfFetchedResultsController = _zfFetchedResultsController;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [JSMCoreDataHelper performFetchOnFetchedResultController:self.fetchedResultsController];
}

#pragma mark - must be overrite by the subclass
-(NSFetchedResultsController *) fetchedResultsController {
    if (self.zfFetchedResultsController != nil) {
        return self.zfFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass(Zeitfenster.class) inManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    fetchRequest.entity = entityDescription;
    fetchRequest.fetchBatchSize = 64;
    
    NSSortDescriptor *sortArztname = [[NSSortDescriptor alloc] initWithKey:cEntityAttributeArztNachname ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObject:sortArztname];
    
    [fetchRequest setSortDescriptors:sortArray];
    
    self.zfFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[JSMCoreDataHelper managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.zfFetchedResultsController.delegate = self;
    
    return self.zfFetchedResultsController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ZFensterIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Zeitfenster *zeitfenster = (Zeitfenster *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",zeitfenster.arzt.anrede, zeitfenster.arzt.nachname];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@h%@-%@h%@ (%@)", zeitfenster.anfangStunde,zeitfenster.anfangMinunte,zeitfenster.endStunde,zeitfenster.endMinute, [self ermittleTermineStatus:zeitfenster.termin]];
    
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.detailTextLabel setAdjustsFontSizeToFitWidth:YES];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddStaticTableViewController *addStaticTableViewController = [segue destinationViewController];
    addStaticTableViewController.selectedZeitfenster = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
}

-(NSString*) ermittleTermineStatus: (Termin *) termin {
    if (termin == nil) {
        return @"frei";
    }
    return @"besetzt";
}

@end
