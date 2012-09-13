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
@property (unsafe_unretained, nonatomic) IBOutlet GearView *headView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *shouldersView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *torsoView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *feetView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *handsView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *legsView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *bracersView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *mainHandView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *offHandView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *waistView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *leftFingerView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *rightFingerView;
@property (unsafe_unretained, nonatomic) IBOutlet GearView *neckView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIView *gearsView;
@property (strong, nonatomic) IBOutlet UITableView *attributesTableView;
@property (strong, nonatomic) IBOutlet AttributesDataSource *attributesDataSource;
@property (strong, nonatomic) IBOutlet SkillsViewController *skillsViewController;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sectionsControl;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *heroNameLabel;

@property (nonatomic, strong) NSDictionary* hero;
@property (nonatomic, assign) BOOL fallen;

- (IBAction)onChangeSection:(id)sender;
@end
