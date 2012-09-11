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

@interface ProfilesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, ProfileHeaderViewDelegate>
@property (assign, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) IBOutlet HeroViewController* heroViewController;

@end
