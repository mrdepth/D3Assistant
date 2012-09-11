//
//  PassiveSkillInfoCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassiveSkillInfoCellView : UITableViewCell
@property (assign, nonatomic) IBOutlet UIImageView *skillImageView;
@property (assign, nonatomic) IBOutlet UILabel *skillDescriptionLabel;
@property (assign, nonatomic) IBOutlet UILabel *levelLabel;
@end
