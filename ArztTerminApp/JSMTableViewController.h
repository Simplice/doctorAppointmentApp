//
//  JSMTableViewController.h
//  ArztTerminApp
//
//  Created by Simplice Tchoupkoua on 26.01.13.
//  Copyright (c) 2013 Simplice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JSMTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSPredicate *searchFetchPredicate; // use for the searchBar

// This method was declare visible, because a child class could oviride it
-(void) barButtonItemEditPressed: (id) sender;

// die Methode impelementieren
-(NSFetchedResultsController *) fetchedResultsController;

@end
