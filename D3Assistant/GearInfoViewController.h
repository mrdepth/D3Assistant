//
//  GearInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GearInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) IBOutlet UIImageView *nameFrameImageView;
@property (assign, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) IBOutlet UILabel *itemLevelLabel;
@property (assign, nonatomic) IBOutlet UILabel *requiredLevelLabel;

@property (nonatomic, strong) NSDictionary* gear;
@property (nonatomic, strong) NSString* slot;

@end
