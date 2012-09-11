//
//  SkillInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkillInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) IBOutlet UILabel *skillNameLabel;
@property (nonatomic, strong) NSDictionary* activeSkill;
@property (nonatomic, strong) NSDictionary* passiveSkill;
@property (nonatomic, strong) NSArray* runes;

@end
