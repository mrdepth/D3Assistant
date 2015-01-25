//
//  DAHeroStatsViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 03.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "d3ce.h"

@interface DAHeroStatsViewController : UITableViewController
@property (nonatomic, assign) std::shared_ptr<d3ce::Hero> hero;
@end
