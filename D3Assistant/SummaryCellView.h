//
//  SummaryCellView.h
//  D3Assistant
//
//  Created by mr_depth on 30.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCellView : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* damageLabel;
@property (nonatomic, weak) IBOutlet UILabel* defenseLabel;
@property (nonatomic, weak) IBOutlet UILabel* hitPointsLabel;

@end
