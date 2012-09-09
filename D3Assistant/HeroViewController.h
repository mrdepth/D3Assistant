//
//  HeroViewController.h
//  D3Assistant
//
//  Created by mr_depth on 06.09.12.
//  Copyright (c) 2012 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GearView.h"
#import "AttributesDataSource.h"
#import "SkillsViewController.h"

@interface HeroViewController : UIViewController<GearViewDelegate>
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
@property (strong, nonatomic) IBOutlet UIView *gearsView;
@property (strong, nonatomic) IBOutlet UITableView *attributesTableView;
@property (strong, nonatomic) IBOutlet AttributesDataSource *attributesDataSource;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet SkillsViewController *skillsViewController;

@property (nonatomic, strong) NSDictionary* hero;

- (IBAction)onChangeSection:(id)sender;
@end
