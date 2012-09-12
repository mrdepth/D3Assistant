//
//  ArmorBaseInfoView.h
//  D3Assistant
//
//  Created by mr_depth on 08.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArmorBaseInfoView : UIView
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *itemColorImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *itemEffectImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *typeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *subtypeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *classLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *armorValueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *armorLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *blockChanceValueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *blockChanceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *blockAmountValueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *blockAmountLabel;

@property (nonatomic, strong) NSDictionary* armor;

@end
