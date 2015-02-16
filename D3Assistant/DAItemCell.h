//
//  DAItemCell.h
//  D3Assistant
//
//  Created by Artem Shimanski on 15.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* itemColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView* itemImageView;
@property (weak, nonatomic) IBOutlet UILabel* itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* damageLabel;
@property (weak, nonatomic) IBOutlet UILabel* toughnessLabel;
@property (weak, nonatomic) IBOutlet UILabel* healingLabel;
@property (weak, nonatomic) IBOutlet UILabel* heroNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* itemLevelLabel;
@property (strong, nonatomic) id object;

@end
