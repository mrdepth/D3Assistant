//
//  GearInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GearInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *nameFrameImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *itemLevelLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *requiredLevelLabel;

@property (nonatomic, strong) NSDictionary* gear;
@property (nonatomic, strong) NSString* slot;

@end
