//
//  SkillsViewController.h
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveSkillView.h"
#import "PassiveSkillView.h"

@interface SkillsViewController : UIViewController<ActiveSkillViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutletCollection(ActiveSkillView) NSArray *activeSkills;
@property (strong, nonatomic) IBOutletCollection(PassiveSkillView) NSArray *passiveSkills;

@property (nonatomic, strong) NSDictionary* hero;

@end
