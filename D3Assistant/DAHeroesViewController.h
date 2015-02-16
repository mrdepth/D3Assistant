//
//  DAHeroesViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 09.10.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAProfile;
@interface DAHeroesViewController : UITableViewController
@property (nonatomic, strong) DAProfile* profile;
@end
