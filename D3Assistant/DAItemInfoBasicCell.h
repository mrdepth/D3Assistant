//
//  DAItemInfoBasicCell.h
//  D3Assistant
//
//  Created by Artem Shimanski on 17.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAItemInfoBasicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* itemColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView* itemImageView;
@property (weak, nonatomic) IBOutlet UILabel* itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* baseStatLabel;
@property (weak, nonatomic) IBOutlet UILabel* baseStatNameLabel;
@property (weak, nonatomic) IBOutlet UILabel* stat1Label;
@property (weak, nonatomic) IBOutlet UILabel* stat2Label;

@end
