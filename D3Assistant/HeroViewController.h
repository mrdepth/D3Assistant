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
@property (assign, nonatomic) IBOutlet GearView *headView;
@property (assign, nonatomic) IBOutlet GearView *shouldersView;
@property (assign, nonatomic) IBOutlet GearView *torsoView;
@property (assign, nonatomic) IBOutlet GearView *feetView;
@property (assign, nonatomic) IBOutlet GearView *handsView;
@property (assign, nonatomic) IBOutlet GearView *legsView;
@property (assign, nonatomic) IBOutlet GearView *bracersView;
@property (assign, nonatomic) IBOutlet GearView *mainHandView;
@property (assign, nonatomic) IBOutlet GearView *offHandView;
@property (assign, nonatomic) IBOutlet GearView *waistView;
@property (assign, nonatomic) IBOutlet GearView *leftFingerView;
@property (assign, nonatomic) IBOutlet GearView *rightFingerView;
@property (assign, nonatomic) IBOutlet GearView *neckView;
@property (strong, nonatomic) IBOutlet UIView *gearsView;
@property (strong, nonatomic) IBOutlet UITableView *attributesTableView;
@property (strong, nonatomic) IBOutlet AttributesDataSource *attributesDataSource;
@property (assign, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet SkillsViewController *skillsViewController;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sectionsControl;

@property (nonatomic, strong) NSDictionary* hero;
@property (nonatomic, assign) BOOL fallen;

- (IBAction)onChangeSection:(id)sender;
@end
