//
//  JSMTableViewController.m
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 26.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import "JSMTableViewController.h"
#import "JSMCoreDataHelper.h"

@interface JSMTableViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UIBarButtonItem *barButtonItemEdit;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemDone;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemCancel;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemAdd;
@property (nonatomic, strong) UIBarButtonItem *barButtonItemSearch;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation JSMTableViewController

@synthesize barButtonItemAdd = _barButtonItemAdd, barButtonItemCancel = _barButtonItemDelete, searchBar = _searchBar,
barButtonItemDone = _barButtonItemDone, barButtonItemEdit = _barButtonItemEdit, barButtonItemSearch= _barButtonItemSearch;

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
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.barButtonItemEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(barButtonItemEditPressed:)];
    self.barButtonItemDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(barButtonItemDonePressed:)];
    self.barButtonItemCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(barButtonItemCancelPressed:)];
    self.barButtonItemAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(barButtonItemAddPressed:)];
    self.barButtonItemSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(barButtonItemSearchPressed:)];
    
    // Setzen der rightBarButtons
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.barButtonItemSearch, self.barButtonItemEdit, nil];
    
    //Toolbars aufbauen
    self.toolbarItems = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.barButtonItemAdd, nil];
    // Style den Toolbar setzen
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    
    // searchbar
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    [self.searchBar setShowsCancelButton:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.fetchedResultsController.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

#pragma mark - must be overrite by the subclass
-(NSFetchedResultsController *) fetchedResultsController {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Die methode %@ von der Vater-Klasse muss überschrieben werden", NSStringFromSelector(_cmd)] userInfo:nil];
}

#pragma mark - barButtonItems
/*********************************************
 this method just call the addViewController
 ********************************************/

-(void) barButtonItemAddPressed: (id) sender {
    NSLog(@"Will be override in the Subclass");
}

-(void) barButtonItemSearchPressed: (id) sender {
    //Check if searchbar is visible
    if(self.tableView.tableHeaderView == nil) { // Die Searchbar is noch nicht da
        [self.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchBar;
        [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:NO];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        self.searchBar.text = nil;
        //       [self searchBar:self.searchBar textDidChange:nil];
        if (self.tableView.contentOffset.y <= self.tableView.tableHeaderView.frame.size.height) { //fi tableheaderview sichtbar ist
            [self.tableView setContentOffset:CGPointMake(0, self.searchBar.frame.size.height) animated:YES];
            
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.tableView.tableHeaderView = nil;
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            });
        } else {
            CGFloat yOffset = self.tableView.contentOffset.y - self.tableView.tableHeaderView.frame.size.height;
            self.tableView.tableHeaderView = nil;
            [self.tableView setContentOffset:CGPointMake(0, yOffset) animated:NO];
        }
    }
}

-(void) barButtonItemEditPressed: (id) sender {
    //Show toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.tableView setEditing:YES];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemSearch,
                                                 self.barButtonItemDone, nil] animated:YES];
    [self.navigationItem setLeftBarButtonItem:self.barButtonItemCancel animated:YES];
}

-(void) barButtonItemDonePressed: (id) sender {
    // first we persit in the database all changing
    [JSMCoreDataHelper saveManagedObjectContext:[JSMCoreDataHelper managedObjectContext]];
    //hide toolbar
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView setEditing:NO];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemSearch, self.barButtonItemEdit, nil] animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    //SHOW backbarButtonItem again
    //[self.navigationItem setHidesBackButton:NO animated:YES];
    
}

-(void) barButtonItemCancelPressed: (id) sender {
    // Rollback all changing
    [[JSMCoreDataHelper managedObjectContext] rollback];
    //hide toolbar
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView setEditing:NO];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:self.barButtonItemSearch, self.barButtonItemEdit, nil] animated:YES];
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - Methods of NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
