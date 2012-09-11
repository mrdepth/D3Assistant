//
//  PassiveSkillView.h
//  D3Assistant
//
//  Created by mr_depth on 09.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PassiveSkillView;
@protocol PassiveSkillViewDelegate <NSObject>
- (void) didSelectPassiveSkillView:(PassiveSkillView*) passiveSkillView;
@end

@interface PassiveSkillView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic) IBOutlet UIImageView *skillImageView;
@property (assign, nonatomic) IBOutlet UILabel *skillNameLabel;
@property (assign, nonatomic) IBOutlet UIImageView *frameImageView;
@property (assign, nonatomic) IBOutlet id<PassiveSkillViewDelegate> delegate;

@property (nonatomic, strong) NSDictionary* skill;

- (IBAction)onTap:(id)sender;

@end
