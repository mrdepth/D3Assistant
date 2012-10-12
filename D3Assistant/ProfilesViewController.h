//
//  ProfilesViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 04.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileHeaderView.h"
#import "HeroViewController.h"
#import "CollapsableTableView.h"

@interface ProfilesViewController : UIViewController<UITableViewDataSource, CollapsableTableViewDelegate, UISearchDisplayDelegate, ProfileHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HeroViewController* heroViewController;

- (void) didSelectHero:(NSDictionary*) hero;
- (IBAction)onDonate:(id)sender;

@end
