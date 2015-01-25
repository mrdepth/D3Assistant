//
//  DAProfilesTableViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 16.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAProfilesTableViewController : UITableViewController
@property (nonatomic, strong) NSFetchedResultsController* resultsController;

- (void) didChangeRegion:(NSNotification*) notification;

@end
