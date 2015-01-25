//
//  DAPassiveSkillInfoViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 13.01.15.
//  Copyright (c) 2015 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPassiveSkillInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UILabel *skillNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLevelLabel;
@property (strong, nonatomic) NSDictionary* skill;

@end
