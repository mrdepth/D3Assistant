//
//  WeaponBaseInfoView.h
//  D3Assistant
//
//  Created by mr_depth on 07.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeaponBaseInfoView : UIView
@property (assign, nonatomic) IBOutlet UIImageView *itemColorImageView;
@property (assign, nonatomic) IBOutlet UIImageView *itemEffectImageView;
@property (assign, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (assign, nonatomic) IBOutlet UILabel *typeLabel;
@property (assign, nonatomic) IBOutlet UILabel *subtypeLabel;
@property (assign, nonatomic) IBOutlet UILabel *classLabel;
@property (assign, nonatomic) IBOutlet UILabel *dpsLabel;
@property (assign, nonatomic) IBOutlet UILabel *damageValueLabel;
@property (assign, nonatomic) IBOutlet UILabel *damageLabel;
@property (assign, nonatomic) IBOutlet UILabel *apsValueLabel;
@property (assign, nonatomic) IBOutlet UILabel *apsLabel;

@property (nonatomic, strong) NSDictionary* weapon;

@end
