//
//  DAItemInfoStatCell.h
//  D3Assistant
//
//  Created by Artem Shimanski on 02.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAItemInfoStatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *affixTypeImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indentationConstraint;

@end
