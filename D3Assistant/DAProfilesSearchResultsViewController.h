//
//  DAProfilesSearchResultsViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 16.12.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "DAProfilesTableViewController.h"

@interface DAProfilesSearchResultsViewController : DAProfilesTableViewController<UISearchResultsUpdating>
- (void) search;
@end