//
//  WeaponBaseInfoView.h
//  D3Assistant
//
//  Created by mr_depth on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeaponBaseInfoView : UIView
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *itemColorImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *itemEffectImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *typeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *subtypeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *classLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dpsLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *damageValueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *damageLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *apsValueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *apsLabel;

@property (nonatomic, strong) NSDictionary* weapon;

@end
