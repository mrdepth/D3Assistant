//
//  ArmorBaseInfoView.h
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArmorBaseInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *itemColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemEffectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *armorValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *armorLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockChanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockChanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockAmountValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *blockAmountLabel;

@property (nonatomic, strong) NSDictionary* armor;

@end
