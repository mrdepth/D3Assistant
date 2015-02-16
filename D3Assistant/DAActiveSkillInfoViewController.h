//
//  DAActiveSkillInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 13.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAActiveSkillInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UIImageView *runeImageView;
@property (weak, nonatomic) IBOutlet UILabel *skillNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *runeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *runeDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *runeLevelLabel;
@property (strong, nonatomic) NSDictionary* skill;

@end
