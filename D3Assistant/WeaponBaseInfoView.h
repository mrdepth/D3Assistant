//
//  WeaponBaseInfoView.h
//  D3Assistant
//
//  Created by mr_depth on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeaponBaseInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *itemColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemEffectImageView;
@property (weak, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *dpsLabel;
@property (weak, nonatomic) IBOutlet UILabel *damageValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *damageLabel;
@property (weak, nonatomic) IBOutlet UILabel *apsValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *apsLabel;

@property (nonatomic, strong) NSDictionary* weapon;

@end
