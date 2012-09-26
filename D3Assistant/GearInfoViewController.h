//
//  GearInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GearInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *nameFrameImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *itemLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *requiredLevelLabel;

@property (nonatomic, strong) NSDictionary* hero;
@property (nonatomic, strong) NSDictionary* gear;
@property (nonatomic, strong) NSString* slot;

@end
