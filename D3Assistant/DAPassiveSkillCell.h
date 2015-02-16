//
//  DAPassiveSkillCell.h
//  D3Assistant
//
//  Created by Artem Shimanski on 12.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPassiveSkillCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UILabel *skillNameLabel;
@property (strong, nonatomic) id object;

@end
