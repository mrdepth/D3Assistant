//
//  ArmorBaseInfoView.h
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArmorBaseInfoView : UIView
@property (assign, nonatomic) IBOutlet UIImageView *itemColorImageView;
@property (assign, nonatomic) IBOutlet UIImageView *itemEffectImageView;
@property (assign, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (assign, nonatomic) IBOutlet UILabel *typeLabel;
@property (assign, nonatomic) IBOutlet UILabel *subtypeLabel;
@property (assign, nonatomic) IBOutlet UILabel *classLabel;
@property (assign, nonatomic) IBOutlet UILabel *armorValueLabel;
@property (assign, nonatomic) IBOutlet UILabel *armorLabel;
@property (assign, nonatomic) IBOutlet UILabel *blockChanceValueLabel;
@property (assign, nonatomic) IBOutlet UILabel *blockChanceLabel;
@property (assign, nonatomic) IBOutlet UILabel *blockAmountValueLabel;
@property (assign, nonatomic) IBOutlet UILabel *blockAmountLabel;

@property (nonatomic, strong) NSDictionary* armor;

@end
