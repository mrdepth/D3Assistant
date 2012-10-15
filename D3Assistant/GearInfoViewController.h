//
//  GearInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3CEHelper.h"

@interface GearInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *nameFrameImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *itemLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *requiredLevelLabel;

@property (nonatomic, strong) NSDictionary* hero;
@property (nonatomic, strong) NSDictionary* gear;
@property (nonatomic, strong) NSDictionary* compareHero;
@property (nonatomic, strong) NSDictionary* compareGear;
@property (nonatomic, strong) NSString* slot;
@property (nonatomic, assign) d3ce::Party* party;
@property (nonatomic, assign, getter = isActiveCompareHero) BOOL activeCompareHero;

@end
