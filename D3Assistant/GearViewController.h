//
//  GearViewController.h
//  D3Assistant
//
//  Created by Artem Shimanski on 18.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GearView.h"
#import "D3CEHelper.h"

@interface GearViewController : UIViewController<GearViewDelegate>
@property (weak, nonatomic) IBOutlet GearView *headView;
@property (weak, nonatomic) IBOutlet GearView *shouldersView;
@property (weak, nonatomic) IBOutlet GearView *torsoView;
@property (weak, nonatomic) IBOutlet GearView *feetView;
@property (weak, nonatomic) IBOutlet GearView *handsView;
@property (weak, nonatomic) IBOutlet GearView *legsView;
@property (weak, nonatomic) IBOutlet GearView *bracersView;
@property (weak, nonatomic) IBOutlet GearView *mainHandView;
@property (weak, nonatomic) IBOutlet GearView *offHandView;
@property (weak, nonatomic) IBOutlet GearView *waistView;
@property (weak, nonatomic) IBOutlet GearView *leftFingerView;
@property (weak, nonatomic) IBOutlet GearView *rightFingerView;
@property (weak, nonatomic) IBOutlet GearView *neckView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *heroNameLabel;

@property (nonatomic, strong) NSDictionary* hero;
@property (nonatomic, strong) NSDictionary* gears;
@property (nonatomic, assign) d3ce::Party* party;
@property (nonatomic, strong) NSDictionary* compareHero;
@property (nonatomic, strong) NSDictionary* compareGears;
@property (nonatomic, assign) d3ce::Party* compareParty;
@property (nonatomic, assign, getter = isActiveCompareHero) BOOL activeCompareHero;


@end
