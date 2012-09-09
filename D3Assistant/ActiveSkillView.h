//
//  ActiveSkillView.h
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActiveSkillView;
@protocol ActiveSkillViewDelegate <NSObject>
- (void) didSelectActiveSkillView:(ActiveSkillView*) activeSkillView;
@end

@interface ActiveSkillView : UIView
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *skillImageView;
@property (weak, nonatomic) IBOutlet UIImageView *runeImageView;
@property (weak, nonatomic) IBOutlet UILabel *skillNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *runeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillOrderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *skillOrderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *frameImageView;
@property (weak, nonatomic) IBOutlet id<ActiveSkillViewDelegate> delegate;

@property (nonatomic, strong) NSDictionary* skill;
@property (nonatomic, strong) NSDictionary* rune;
@property (nonatomic, assign) NSInteger order;

- (IBAction)onTap:(id)sender;

@end
