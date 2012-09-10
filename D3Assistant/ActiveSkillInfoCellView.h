//
//  ActiveSkillInfoCellView.h
//  D3Assistant
//
//  Created by Artem Shimanski on 10.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveSkillInfoCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UILabel *skillDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end
